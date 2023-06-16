module ApplicationHelper
    def gravatar_for(user, options = {size: 80})
        
        email_address = user.email.downcase
        hash = Digest::MD5.hexdigest(email_address)
        size = options[:size]

        image_src = "https://static1.personality-database.com/profile_images/af3fc4a4bfbf47c59a3de207ac82c20f.png"
        image_tag(image_src, alt: user.username, class: 'rounded-circle')
    end

end
