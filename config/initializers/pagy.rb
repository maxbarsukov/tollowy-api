require 'pagy/extras/searchkick'

Searchkick.extend Pagy::Searchkick

Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:max_per_page] = 100
