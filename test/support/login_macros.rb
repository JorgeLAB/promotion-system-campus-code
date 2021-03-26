module LoginMacros
  def login_user(user = User.create!(email: "mclovin@iugu.com.br", password: "1234567"))
    login_as user, scope: :user
  end
end
