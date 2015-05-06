class ApplicationController < ActionController::Base
  respond_to :html, :json
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def check_admin_signed_in
    if not admin_signed_in?
      render json: {message: "Please sign in"}
    end
  end

  def check_admin_have_gym_permission
    admin_id = current_admin
    gym_id = params["gym_id"]
    if not AdminGymList.find_by(admin_id: admin_id, gym_id: gym_id) != nil
      render json: {message: "You don't have permission"}
    end
  end

  def check_admin_have_company_permission
    admin_id = current_admin
    company_id = params["company_id"]
    if not Admin.find_by(id: admin_id, company_id: company_id) != nil
      render json: {message: "You don't have permission"}
    end
  end

  protected
  # In Rails 4.1 and below
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end
end
