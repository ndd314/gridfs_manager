module ApiHelpers
  def payload
    JSON.parse last_response.body
  end

  def post_json(url, json={})
    post url, json, "CONTENT_TYPE" => "application/json"
  end
end
