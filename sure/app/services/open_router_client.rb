class OpenRouterClient
  def initialize(api_key = ENV['OPENROUTER_API_KEY'])
    @api_key = api_key
    @url = 'https://openrouter.dev/api/v1/chat/completions'
  end

  def chat(prompt)
    response = HTTParty.post(@url,
      headers: {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json'
      },
      body: {
        model: 'anthropic/claude-3-haiku',
        messages: [{ role: 'user', content: prompt }]
      }.to_json
    )
    JSON.parse(response.body)['choices'][0]['message']['content']
  rescue => e
    "Error: #{e.message}"
  end
end
