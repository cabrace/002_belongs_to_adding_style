
Adding Styling :  With Bulma CSS Framework
-----

Terminal
```
yarn add bulma
```

Application Layout  
`app/views/layouts/application.html.erb`
``` erb
 <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %> 
 <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %> 
```
Make sure we have the `stylesheet_pack_tag` instead of the `stylesheet_link_tag`. This is for `Webpacker` usage, otherwise keep it as default
and use the `rails-bulma` gem **if** using `Sprockets` instead.

> in app/javascript/packs/application.scss
``` scss
.table.is-borderless{
  border:0 !important;
  border: 1px solid red;
}

 //Set your brand colors
$purple: #8A4D76;
$purple-1: #8a4d762b;
$pink: #FA7C91;
$brown: #757763;
$brown-1: #7577632e;
$beige-light: #D0D1CD;
$beige-lighter: #EFF0EB;
$white: #fff;

// Update Bulma's global variables
$family-sans-serif: "Nunito", sans-serif;
$grey-dark: $brown;
$grey-light: $beige-light;
$primary: $purple;
$link: $pink;
$widescreen-enabled: false;
$fullhd-enabled: false;

// Update some of Bulma's component variables
$body-background-color: $beige-lighter;
$control-border-width: 2px;
$input-border-color: transparent;
$input-shadow: none;

.table.is-borderless td, .table.is-borderless th {
 //border: 0;
 border: 1px solid #dbdbdb;
}


@import "bulma"
```
This `application.scss` css file is created in the `app/javascript/packs` folder. Here we added a default color scheme for the application.
Make sure the `@import "bulma"` is added **after** the styling. And that's it. Reload the Rails application and the Bulma framework along with styling should be applied.

Adding Navigation
---
Using Bulma [Tabs](https://bulma.io/documentation/components/tabs/) as a navigation header we will use the following code in a Rails `partial` section.

Create the `app/views/layouts/_tabs.html.erb` section and add the following code:

#### The Partial
``` erb
<div class="tabs has-text-primary">
  <ul>
    <li class="<%= is_active?(:authors) %>" >
      <%= link_to "Authors", authors_path %>
    </li>
    <li class="<%= active_page?(:books) %>">
      <%= link_to "Books", books_path %>
    </li>
  </ul>
</div>
```
Generally we may use something like `active_link_to` gem for adding the class `active` to the resource currently being visited; however the Bulma class is applied to the parent `<li>` tag for it to work, so in this case we wil wrtite our own `ApplicationHelper` functionality as we see above with the `erb` sections that have `active_page?` and `is_active?` methods.

#### ApplicationHelper 
In the `app/helpers/application_helper.rb`
```ruby
module ApplicationHelper
  #REf: https://gist.github.com/mynameispj/5692162
  def active_page?(current_page)
    return unless request.path.include?(current_page.to_s)
    'is-active'
  end

  #Take your pick: these two do the same thing!
  def is_active?(current_page)
    return "is-active" if params[:controller] == current_page.to_s
  end
end

```

Note we have **two** different helpers here, abd basically they do the **same** thing, its just different ways of coding it, pick whicher looks better and name it how you like I just did both as demo purposes.

Once we have the `partial` view and the `ApplicationHelper` functions created we can then add the following to the `layout` section.

Generally in the `app/views/layouts/application.html.erb` may have a `body` section that looks like this
``` erb
  <body>
    <header>
      <nav>
        <%= render "layouts/tabs" %>
      </nav>
    </header>

    <section class="section">
      <%= yield %>
    </section>
    
    <footer>
    </footer>
  </body>
```
Here we are using the Tabs section as a very simple navigation structure between the Model views. We will build this out and channge the sections
once the application becomes more complicated.

