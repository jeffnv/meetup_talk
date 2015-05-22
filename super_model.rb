class ARBase
end

class User < ARBase
  @columns = [:name, :password_digest, :session_token]
  def name
    super + "!!!"
  end

end
