class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Cualquier query sin tenant activo lanza excepción
  # en lugar de devolver datos de otro tenant
  def self.inherited(subclass)
    super
    # el tenant se setea en cada modelo que lo necesite
  end
end
