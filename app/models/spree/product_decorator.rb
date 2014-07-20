Spree::Product.class_eval do
  def size_guide_url
    taxon = taxons.last
    unless taxon && taxon.permalink.index("shoes")
      return nil
    end

    root_taxon = taxons.last.root.permalink
    root_taxon = "kid" if (root_taxon == "boys" || root_taxon == "girls")
    return "shoe-size/#{root_taxon}s.jpg"
  end

  def option_values
    @_option_values ||= Spree::OptionValue.for_product(self)
  end

  def grouped_option_values
    @_grouped_option_values ||= option_values.group_by(&:option_type)
    @_grouped_option_values.sort_by { |option_type, option_values| option_type.position }
  end

  def variants_for_option_value(value)
    @_variant_option_values ||= variants.includes(:option_values)
    @_variant_option_values.select { |i| i.option_value_ids.include?(value.id) }
  end

  def variant_options_hash
    return @_variant_options_hash if @_variant_options_hash
    hash = {}
    variants.includes(:option_values).each do |variant|
      variant.option_values.each do |ov|
        otid = ov.option_type_id.to_s
        ovid = ov.id.to_s
        hash[otid] ||= {}
        hash[otid][ovid] ||= {}
        hash[otid][ovid][variant.id.to_s] = variant.to_hash
      end
    end
    @_variant_options_hash = hash
  end

end
