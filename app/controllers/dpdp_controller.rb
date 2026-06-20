class DpdpController < ApplicationController
  skip_before_action :require_onboarding, only: [:consent, :consent_status]

  def consent
    user = current_user
    return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

    record = user.consent_records.create!(
      feature: params[:feature],
      granted: params[:granted],
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      granted_at: Time.current
    )

    if params[:granted]
      user.update!(consent_granted: true, consent_granted_at: Time.current)
    end

    render json: { success: true, consent: record }
  end

  def consent_status
    user = current_user
    return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

    records = user.consent_records.active
    status = ConsentRecord::FEATURES.index_with do |feature|
      records.any? { |r| r.feature == feature }
    end

    render json: { consent: status }
  end

  def erasure
    user = current_user
    return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

    if user.deletion_requests.pending.exists?
      return render json: { error: 'A deletion request is already pending' }, status: :conflict
    end

    request_record = user.deletion_requests.create!(
      export_data: params.fetch(:export_data, true),
      notes: params[:notes]
    )

    render json: {
      success: true,
      message: 'Deletion request submitted. You have 48 hours to cancel.',
      cancel_token: request_record.cancel_token,
      scheduled_for: request_record.scheduled_for
    }
  end

  def cancel_deletion
    user = current_user
    return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

    request_record = user.deletion_requests.pending.find_by!(cancel_token: params[:cancel_token])
    request_record.cancel!

    render json: { success: true, message: 'Deletion request cancelled.' }
  end
end
