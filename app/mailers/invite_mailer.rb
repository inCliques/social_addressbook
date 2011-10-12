class InviteMailer < ActionMailer::Base
  default :from => "no-reply@incliqu.es"

  def send_invitation(inviter, invitee, group)
    require 'ruby-debug'
    debugger
    invitee_mail = invitee.get_datum_of_type('Email').first.value
    @link = new_user_registration_url+'?email='+invitee_email
    @inviter = inviter
    @invitee = invitee
    @group = group

    subject = @inviter.name+" invites you to join the "+group.name+" clique"
    mail(:to => invitee_email, :subject => subject)
  end  
end
