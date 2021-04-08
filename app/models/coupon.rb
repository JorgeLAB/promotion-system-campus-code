class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, disabled: 10 }
  delegate :discount_rate, to: :promotion
  delegate :expiration_date, to: :promotion

  class << self

    def search(code)
      return 'Código inválido' unless code_valid? code
      return 'Código não encontrado' if find_by(code: code).nil?

      find_by(code: code)
    end

    def code_valid?(code)
      code =~ /^([A-Z0-9]+)-(\d+)$/
    end
  end
end

=begin
  Criei métodos de uso geral para busca de coupons mas
  estou colocando no routes que para realizar uma busca tenho de ter um promotion para retornar a show
  o que não deveria ser necessário.
=end
