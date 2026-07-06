class DpdpController < ApplicationController
  skip_before_action :check_onboarding, only: [:consent, :consent_status]

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

  def full_export
    user = current_user
    return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

    export = {
      exported_at: Time.current.iso8601,
      user: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        currency: user.currency,
        locale: user.locale,
        timezone: user.timezone,
        onboarded: user.onboarded,
        created_at: user.created_at,
        updated_at: user.updated_at
      },
      consent_records: user.consent_records.order(created_at: :desc).map { |r|
        { feature: r.feature, granted: r.granted, granted_at: r.granted_at, revoked_at: r.revoked_at }
      },
      deletion_requests: user.deletion_requests.order(created_at: :desc).map { |r|
        { status: r.status, scheduled_for: r.scheduled_for, created_at: r.created_at }
      },
      debts: user.debts.order(created_at: :desc),
      portfolios: user.portfolios.order(created_at: :desc).map { |p|
        p.as_json(include: :investments)
      },
      journeys: user.journeys.order(created_at: :desc),
      net_worth_snapshots: user.net_worth_snapshots.order(snapshot_date: :desc).limit(100),
      recurring_expenses: user.recurring_expenses.order(created_at: :desc),
      transactions: user.transactions.order(transaction_date: :desc).limit(500),
      budgets: user.budgets.order(created_at: :desc),
      trips: user.trips.order(created_at: :desc),
      conversations: user.conversations.order(created_at: :desc).map { |c|
        { id: c.id, title: c.title, messages: c.messages.order(created_at: :asc).map { |m|
          { role: m.role, content: m.content, created_at: m.created_at }
        }}
      },
      grievances: user.grievances.order(created_at: :desc)
    }

    render json: export
  end

  def grievance
    user = current_user
    return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

    record = user.grievances.create!(
      name: params[:name] || "#{user.first_name} #{user.last_name}",
      email: params[:email] || user.email,
      phone: params[:phone],
      grievance_type: params[:grievance_type],
      description: params[:description],
      acknowledged_at: Time.current
    )

    render json: {
      success: true,
      reference_number: record.reference_number,
      status: 'received',
      expected_response: '72 hours',
      expected_resolution: '90 days',
      message: 'Grievance received. We will respond within 72 hours.'
    }
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
