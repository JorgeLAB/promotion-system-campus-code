class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, disabled: 10 }

  class << self

    def search(code)
      return 'Código inválido' unless code_valid? code

      if find_by(code: code).nil?
        'Código não encontrado'
      else
        find_by(code: code)
      end
    end

    def code_valid?(code)
      code =~ /^([A-Z0-9]+)-(\d+)$/
    end
  end
end
