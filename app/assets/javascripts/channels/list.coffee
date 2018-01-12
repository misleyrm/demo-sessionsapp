App.list = App.cable.subscriptions.create "ListChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # alert(data.html);
    $pageContent = $('#page-content')
    $list = $('[data-list-id = "' + data.id + '"]', $pageContent)
    $user = $('[data-user-id = "' + data.user + '"]', $list)

    $nav = $('[data-nav-id = "' + data.user + '"]')
    $listNav = $('[data-nav-list-id = "' + data.id + '"]', $nav)
    $listTopnavbar = $('[data-topnavbar-list-id = "' + data.id + '"]')
    $chipListTopnavbar =  $('.chip', $listTopnavbar)
    $chipList = $('.chip', $listNav)
    $ul = $('ul#ulCreated', $nav)
    $add = $("#ms-add", $ul)
    $collaborationLists = $("#ulCollaborationList")
    $collUserSettings = $('ul#collaboration-user-settings')  # add to the modal form the list id, and look for the list to add user collaborators.
    # if $task.length > 0
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
        # $( data.htmlLi ).insertBefore $add
      # when 'listCreated'
      #   $("li.active", $ul).removeClass('active');
      #   $( data.htmlLi ).insertBefore $add
      #   $chipListTopnavbar.replaceWith data.htmlChip
          # $task.replaceWith data.html
          # $('.edit_task').submitOnCheck()
          # deadlineDatepicker($('input.deadline-datepicker'));
          # $('input.deadline-datepicker.hidden-datepicker').hover(handlerIn, handlerOut);
        # when 'deleted'
        #   $task.remove()
        #   if (data.blocker) && (data.numBlockers == 0)
        #     $parentTask = $('[data-task-id = "' + data.parentTask + '"]', $user)
        #     $('#menu >ul.menu-option li a#link-blocker i', $parentTask).removeClass('md-red').addClass('md-dark md-inactive')
        # when 'important'
        #   if (data.important)
        #     $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-dark md-inactive').addClass('md-jellow')
        #   else
        #     $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-jellow').addClass('md-dark md-inactive')
        # when 'deletedeadline'
        #     $('ul.menu-information li.ms-deadline', $task).removeClass('active')
        #     if  !($('#menu >ul.menu-option li i.i-btn-datepicker', $task).hasClass('md-dark md-inactive'))
        #       $('#menu >ul.menu-option li i.i-btn-datepicker', $task).addClass('md-dark md-inactive').removeClass('md-red')
        #     $('p#alternate', $task).html('')
        # when 'deadline'
        #   if (data.deadline != "") || (data.deadline != "null")
        #     d = new Date(data.deadline)
        #     date = d.getShortDayWeek()+ ', ' + d.getDate() + ' ' + d.getShortMonth()
        #     $('ul.menu-information li.ms-deadline', $task).addClass('active')
        #     if  $('#menu >ul.menu-option li i.i-btn-datepicker', $task).hasClass('md-dark md-inactive')
        #       $('#menu >ul.menu-option li i.i-btn-datepicker', $task).removeClass('md-dark md-inactive').addClass('md-red')
        #     $('p#alternate', $task).html(date)
        # when 'changelist'
        #   $task.remove()
        #   if (data.num != '')
        #     $('.bar-number-task', $listNav).html data['num']
        #     $('.bar-number-task', $listChangeNav).html data['num_list_change']
        # when 'completed'
        #   $task.remove()
        #   $('#complete_tasks', $user).prepend data['html']
        #   if ($('.divider', $user).hasClass('no-active'))
        #     $('.divider', $user).removeClass('no-active')
        #   if (data.num != '')
        #     $('.bar-number-task', $listNav).html data['num']
        #   $('.edit_task').submitOnCheck()

      # $('.dropdown-button').dropdown()
      # deadlineDatepicker($('input.deadline-datepicker',$list ))
    # else
    #   if data.blocker
    #       $parent = $('[data-task-id = "' + data.parentId + '"]', $user)
    #       $('#show_blockers_' + data.parentId).prepend data['html']
    #       if !($('a#link-blocker > i',$parent).hasClass('md-red'))
    #         $('a#link-blocker > i',$parent).addClass('md-red')
    #         $('a#link-blocker > i',$parent).removeClass('md-inactive')
    #       $('i[data-has-blockers]',$parent).data('data-has-blockers','true')
    #       $('.edit_task').submitOnCheck()
    #
    #   else
    #     $('#incomplete_tasks', $user).prepend data['html']
    #     $('.edit_task').submitOnCheck()
    #     $('#list_user_' + data['user'] + ' .new_task #task_detail').val('');
    #     if (data.num != '')
    #       $('.bar-number-task', $listNav).html data['num']

  # submit_task = () ->
  # $('#new_task #detail').on 'keydown', (event) ->
  #   if event.keyCode is 13
  #     $('#new_task #create_task_button').click()
  #     event.target.value = ""
  #     event.preventDefault()
