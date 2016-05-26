Spree::OptionValue.class_eval do

  has_attached_file :image,
    # :default_style => SpreeVariantOptions::VariantConfig[:option_value_default_style],
    styles: { mini: '48x48>', small: '100x100>', product: '240x240>', middle: '500x500>' },
    default_style: :small,
    :url           => SpreeVariantOptions::VariantConfig[:option_value_url],
    :path          => SpreeVariantOptions::VariantConfig[:option_value_path]
  
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  
  def has_image?
    image_file_name && !image_file_name.empty?
  end

  default_scope { order("#{quoted_table_name}.position") }
  scope :for_product, lambda { |product| select("DISTINCT #{table_name}.*").where("spree_option_values_variants.variant_id IN (?)", product.variant_ids).joins(:variants) }
end
