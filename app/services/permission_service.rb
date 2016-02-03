class PermissionService
  extend Forwardable
  attr_reader :user, :controller, :action
  def_delegators :user, :platform_admin?,
                        :store_admin?,
                        :registered_user?
  def initialize(user)
    @user = user || User.new
  end

  def allow?(controller, action)
    
    @controller = controller
    @action = action

    case
    when platform_admin? then platform_admin_permissions
    when store_admin?    then store_admin_permissions
    else
      guest_user_permissions
    end
  end

  private

    def platform_admin_permissions
      return true if controller == "users" && action.in?(%w(index show))
      store_admin_permissions
    end

    def store_admin_permissions
      return true if controller == "orders" && action.in?(%w(index show))
      guest_user_permissions
    end

    def guest_user_permissions
      return true if controller == "items" && action.in?(%w(index show))
      return true if controller == "sessions" && action.in?(%w(new create destroy))
      return true if controller == "stores" && action.in?(%w(index show))
    end
end
