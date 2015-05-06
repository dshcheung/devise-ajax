class Admin::PasswordsController < Devise::PasswordsController
  def create
    resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: {:success => true, :message => "Email Sent"}, status: 200
    else
      render json: {:success => false, :message => resource.errors}, status: 400
    end
  end

  def update
    resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: {:success => true, :message => "Password resetted"}, status: 200
    else
      render json: {:success => false, :message => resource.errors}, status: 400
    end
  end
end
