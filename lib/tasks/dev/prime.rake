if Rails.env.development?

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: [:environment, "db:setup"] do

      puts "\n=== Criando Usuários ===\n"

      users = Fabricate.times(10,:user)

      puts "   #{users.size} usuários foram gerados. \n"

      puts "=== Criando Promoções ===\n"

      promotions =
        users.flat_map do |user|
          Fabricate.times( rand(0..5), :promotion, user: user )
        end

      puts "   #{promotions.size} promoções foram geradas. \n"

      puts "=== Gerando Coupons ===\n"

      promotions
        .select { |promotion| promotion.coupon_quantity.odd? }
        .each(&:generated_coupons!)

      puts "   Coupons gerados.\n"

      puts "=== Gerando Categorias de Produto ===\n"

      product_categories = Fabricate.times(50, :product_category)

      puts "   #{product_categories.size} Categorias de produto geradas."
    end
  end
end
