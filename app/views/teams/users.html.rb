<div class="section" id="sessions-new">
  <div class="row">
    <div class="col s12 m6">
      <div class="card">
        <div class="card-title">
          <h1 class="col s12 m9">New Session</h1>
          <%= image_tag "new-session.png", :height => "62" %>
          <p>Choose team members</p>
        </div>
        <div class="card-content">
        <%= render :template => "sessions/_form" %> 
          <%= render 'form' %>

        </div>
        <div class="card-action">
          <div class="row center-align">
            <div class="col s12 m4">
              <!--  Create more users section by Santiago -->
              <%= link_to 'New Users', new_user_path %>
            </div>
            <div class="col s12 m5">
              <%= link_to 'Edit Sessions', sessions_path %>
            </div>
            <div class="col s12 m3">
              <%= link_to 'Back', sessions_path %>
            </div>
            <div class="col s12 m12 signed_user">
              Signed in as <%= current_user.first_name.capitalize %> | <%= link_to "Logout", '/logout' %>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>

</div>
