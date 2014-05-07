window.variantOptions = (params) ->
  options = params['options']

  # variant options dropdowns
  $("html").on "click", ".variant-option-values", (e) ->
    e.stopPropagation()
    $(".variant-option-values").not(@).removeClass "active"
    $(@).toggleClass "active"

  # close menus when clicking anywhere on the page
  $("html").on "click", =>
    $(".variant-option-values").removeClass "active"

  # select a variant option
  $("html").on "click", ".option-value", ->
    parent = $(@).parents('.variant-options')
    optionId = $(@).parents(".variant-options").attr("id").split("_")[2]
    optionIndex = $().parents(".variant-options").data("index")
    elemId = $(@).attr("id").split("-")[1]

    # update selected and 'current' text
    $(@).addClass("selected").siblings().removeClass("selected")
    parent.find('.current').html($(@).text())

    # reset options if user selects something that's not in-stock
    unless $(@).hasClass("in-stock")
      parent.find('.option-value').addClass("in-stock")

    # get list of variants that match this option value
    variants = options[optionId][elemId]
    ids = for key of variants
      key

    # reset the other option selector by blacking out all choices
    otherOptionId = $("[data-index=" + (optionIndex + 1) % 2 + "]").attr("id").split("_")[2]
    otherOptionSelector = $("#option_type_" + otherOptionId)
    otherOptionSelector.find(".option-value").removeClass("in-stock")
    # ...then re-enable the ones that are available, and find the variant_id if both options have been selected
    variant_id
    variants = options[otherOptionId]
    for key,variant of variants
      for id in ids
        if typeof variant[id] == "object"
          $("#option-" + key).addClass("in-stock")
          if $("#option-" + key).hasClass("selected")
            $('#variant_id').val(variant[id].id)
            $('#cart-form button[type=submit]').attr('disabled', false)

    # if this selection conflicts with the previous selection, reset the previous selection
    selected = otherOptionSelector.find(".selected")
    current = otherOptionSelector.find(".current")
    unless selected.hasClass("in-stock")
      current.html(current.data("title"))
      selected.removeClass("selected")

    # fade out the cart button if selection is not complete
    unless $(".selected").length == 2
      $('#cart-form button[type=submit]').attr('disabled', true)
    return

