module Methods
  class UserMethods

    def UserMethods.to_user_id( key )

      unless key.empty?
        user = User.find_by( key: key )
        unless user.nil?
          return user.id
        else
          return nil
        end
      else
        return nil
      end
    end
    
  end
end
