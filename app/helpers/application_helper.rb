module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :tab => params[:tab], :search => params[:search]}, {:class => css_class, :title => 'Sort'}
  end

  def title(page_title, options={})
    content_for(:title, 'NutrientNet - ' << page_title.to_s)
  end

  def insert_tabs(tabs)
  end

end
