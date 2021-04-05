module LoginMacros
  def login_user(user = User.create!(name: 'Jorge', email: "mclovin@iugu.com.br", password: "1234567"))
    login_as user, scope: :user
    user
  end
end
