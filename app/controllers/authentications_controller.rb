class AuthenticationsController < ApplicationController
  def weibo
    omniauth = request.env["omniauth.auth"]
    omniauth['credentials']['expires_at'] = Time.at(omniauth['credentials']['expires_at'])
    # raise omniauth.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication
      authentication.access_token = omniauth['credentials']['token']
      authentication.expires_at = omniauth['credentials']['expires_at']
      authentication.save
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(
        :provider => omniauth['provider'],
        :uid => omniauth['uid'],
        :access_token => omniauth['credentials']['token'],
        :expires_at => omniauth['credentials']['expires_at'])

      current_user.apply_omniauth(omniauth)
      redirect_to root_path
    else
      user = User.new
      user.apply_omniauth(omniauth)

      if session[:invitation_token]
        user.invitation_token = session[:invitation_token]
        user.email = user.invitation.recipient_email
      end

      if user.save
        user.follow_project!(user.invitation.project) if user.invitation
        session[:invitation_token] = nil
        sign_in_and_redirect(:user, user)
      else
        session["devise.user_attributes"] = user.attributes
        session["devise.auth"] = user.authentications.first.attributes
        redirect_to sign_up_path
      end
    end
  end

end
