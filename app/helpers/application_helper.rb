module ApplicationHelper
    def gravatar_for(user, options = {size: 150, loc: 0})
        
        email_address = user.email.downcase
        hash = Digest::MD5.hexdigest(email_address)
        size = options[:size]
        loc = options[:loc]
        if loc == 0
        image_src = "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
        else  
        image_src = "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
        end
        image_tag(image_src, alt: user.username, class: 'rounded-circle')
    end

end
