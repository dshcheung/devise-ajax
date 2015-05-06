class Admin::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if params['special_key'] == "abc"
      if resource.save
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          return render json: {:success => true, :message => "success"}, status: 200
        else
          expire_session_data_after_sign_in!
          return render json: {:success => true, :message => "success"}, status: 200
        end
      else
        clean_up_passwords resource
        return render json: {:success => false, :message => resource.errors}, status: 400
      end
    else
      return render json: {:success => false, :message => {secret: ["Secret key not matched"]}}, status: 400
    end
  end

  def update
    resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    if resource_updated
      sign_in resource_name, resource, bypass: true
      render json: {:success => true, :message => "success"}, status: 200
    else
      clean_up_passwords resource
      render json: {:success => false, :message => resource.errors}, status: 400
    end
  end


  protected
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end
  
  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end