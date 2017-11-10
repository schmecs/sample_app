module ApplicationHelper

	def base_title
		"Ruby on Rails Tutorial Sample App"
	end

	#Returns the full title on a per-page basis.
	def full_title(page_title = '')
		if page_title.empty?
			self.base_title
		else
			page_title + " | " + self.base_title
		end
	end
end
