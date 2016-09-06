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

  def listYears
    [
        ['Year 1', 1], ['Year 2', 2], ['Year 3', 3], ['Year 4', 4], ['Year 5', 5], ['Year 6', 6], ['Year 7', 7], ['Year 8', 8], ['Year 9', 9], ['Year 10', 10]
    ]
  end

  def listMonths
    [
        ['01 - January', 1], ['02 - February', 2], ['03 - March', 3], ['04 - April', 4], ['05 - May', 5], ['06 - June', 6], ['07 - July', 7], ['08 - August', 8], ['09 - September', 9], ['10 - October', 10], ['11 - November', 11], ['12 - December', 12]
    ]
  end

  def listDays
    [
        [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [8, 8], [9, 9], [10, 10], [11, 11], [12, 12], [13, 13], [14, 14], [15, 15], [16, 16], [17, 17], [18, 18], [19, 19], [20, 20], [21, 21], [22, 22], [23, 23], [24, 24], [25, 25], [26, 26], [27, 27], [28, 28], [29, 29], [30, 30], [31, 31]
    ]
  end

  def listPasture
    [
      ['Select Type'], ['Altai Wild Rice', 18], ['Annual Rye Grass', 19], ['Bromegrass: Regular', 84], ['Bromegrass: Smooth', 86], ['Buffalo Grass', 52], ['Clover: Alsike', 78], ['Clover: Red', 79], ['Clover: Sweet', 80], ['Eastern Gama Grass', 48], ['Fallow Pasture Grass', 5], ['Fescue', 41], ['Gramagrass', 50], ['Indian Grass', 67], ['Lespedeza Grass', 61], ['Love Grass', 65], ['Mixed Pasture', 90], ['Orchard Grass', 63], ['Pasture: Range', 91], ['Pasture: Summer', 92], ['Pasture: Winter', 93], ['Timothy', 16], ['Winter Peas', 11]
    ]
  end
end
