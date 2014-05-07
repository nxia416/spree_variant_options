Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  def to_hash
    #actual_price  = self.price
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    current_rate = Spree::CurrencyRate.find_by(:base_currency => self.cost_currency)
    actual_price  = number_with_delimiter(current_rate.convert_to_won(self.price.to_s))
    {
      :id    => self.id,
      :in_stock => self.in_stock?,
      :price => actual_price
      #:price => self.display_price
    }
  end

end
