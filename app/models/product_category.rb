class ProductCategory < ApplicationRecord
  validates :name, presence: { message: 'não pode ficar em branco' },
                   uniqueness: { message: 'deve ser único'}

  validates :code, presence: { message: 'não pode ficar em branco' },
                   uniqueness: { message: 'deve ser único'}
end
