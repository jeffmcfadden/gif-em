module ImagesHelper
  def tag_label(tag: tag, show_remove: false)
    content_tag(:span, class: "label #{label_class_for_tag(tag)}") do
      output = [content_tag(:span, tag.tag.name, title: "Confidence: #{tag.confidence}")]
      output << link_to("<i class='fa fa-times'></i>".html_safe, remove_tag_image_path(tag: tag.tag.name), method: :post) if show_remove
      output.join(" ").html_safe
    end
    
  end
  
  def label_class_for_tag(tag)
    if tag.confidence >= 100
      'label-success'
    elsif tag.confidence >= 50
      'label-primary'
    elsif tag.confidence >= 30
      'label-info'
    elsif tag.confidence >= 20
      'label-warning'
    elsif tag.confidence >= 10
      'label-danger'
    else
      'label-default'
    end
  end
end
