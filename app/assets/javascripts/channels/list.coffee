jQuery(document).on 'turbolinks:load', ->
  App.list = App.cable.subscriptions.create "ListChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        html = data.html
        data = data.data
        $pageContent = $('#page-content')
        $list = $('[data-list-id = "' + data.id + '"]', $pageContent)
        $user = $('[data-user-id = "' + data.user + '"]', $list)

        $nav = $('[data-nav-id = "' + data.user + '"]')
        $listNav = $('[data-nav-list-id = "' + data.id + '"]')

        $listTopnavbar = $('[data-topnavbar-list-id = "' + data.id + '"]')
        $chipListTopnavbar =  $('.chip', $listTopnavbar)
        $chipList = $('.chip', $listNav)
        $ul = $('ul#ulCreated', $nav)
        $add = $("#ms-add", $ul)
        $collaborationLists = $("#ulCollaborationList")
        $collUserSettings = $('ul#collaboration-user-settings')  # add to the modal form the list id, and look for the list to add user collaborators.

        switch data.status
          when 'listUpdated'
            $chipList.replaceWith data.htmlChip
            $chipListTopnavbar.replaceWith data.htmlChip
          when 'listUpdatedOwner'
            $beforeOwner = $('[data-nav-id = "' + data.before_owner + '"]')
            $createdListBeforeOwner = $('ul#ulCreated', $beforeOwner)
            $listNavBeforeOwner = $('[data-nav-list-id = "' + data.id + '"]', $createdListBeforeOwner)
            $listNavBeforeOwner.remove()
            $collaborationListsBeforeOwner = $("#ulCollaborationList", $beforeOwner)
            if  ($('[data-nav-list-id = "' + data.id + '"]', $collaborationListsBeforeOwner).lenght = 0 )
              $collaborationListsBeforeOwner.append data.htmlLi
            $( data.htmlLi ).insertBefore $add
            $listNav.remove()
