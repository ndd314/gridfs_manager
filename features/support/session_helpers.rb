module SessionHelpers
  def current_user
    @current_user
  end

  def authenticated
    @authenticated ||= {}
  end

  def authenticated?
    authenticated[Capybara.session_name]
  end

  def authenticate(email: nil)
    return if authenticated?
    user = email && User.find_by(email: email) rescue doctor_who
    login_as user
    @current_user = user
    authenticated[Capybara.session_name] = true
  end
end
