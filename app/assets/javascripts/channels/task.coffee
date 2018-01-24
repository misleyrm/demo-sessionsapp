App.task = App.cable.subscriptions.create "TaskChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $pageContent = $('#page-content')
    $mainCenter = $('#main_center')
    $currentListMainCenter = $('#main_center > div ').data('list-id')
    $list = $('[data-list-id = "' + data.list_id + '"]', $pageContent)
    $user = $('[data-user-id = "' + data.user + '"]', $pageContent)

    # if data.current_user_id           #(data.status == 'changelist') || (data.num != '')
    $nav = $('[data-nav-id = "' + data.user + '"]')
    $listNav = $('[data-nav-list-id = "' + data.list_id + '"]', $nav)
    $listAllTaskNav = $('[data-nav-list-id = "' + data.list_all_task_id + '"]', $nav)
    $listChangeNav = $('[data-nav-list-id = "' + data.list_change + '"]', $nav)

    $incomplete = $('#incomplete_tasks_' + data.user )
    $divCompleted = $('#complete_tasks_' + data.user)
      # $numTask = $('.bar-number-task', $listNav)
    # $('#list_user_' + data['user'] + ' #incomplete_tasks')
    if data.blocker
      $task = $('[data-blocker-id = "' + data.id + '"]')
    else
      $task = $('[data-task-id = "' + data.id + '"]', $user)
    if $task.length > 0
      switch data.status
        when 'saved'
          $task.replaceWith data.html
          $('.edit_task').submitOnCheck()
          deadlineDatepicker($('input.deadline-datepicker'));
          $('input.deadline-datepicker.hidden-datepicker').hover(handlerIn, handlerOut);
          $('.tooltipped').tooltip({delay: 50})
        when 'deleted'
          $("#task_"+ data.id + " #menu .tooltipped").tooltip('remove')
          $task.remove()
          if (data.num != '')
            $('.bar-number-task', $listNav).html data['num']
            $('.bar-number-task', $listAllTaskNav).html data['numAllTask']
          if (data.blocker) && (data.numBlockers == 0)
            $parentTask = $('[data-task-id = "' + data.parentTask + '"]', $user)
            $('#menu >ul.menu-option li a#link-blocker i', $parentTask).removeClass('md-red').addClass('md-dark md-inactive')
        when 'important'
          if (data.important)
            $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-dark md-inactive').addClass('md-jellow')
          else
            $('#menu >ul.menu-option li i#md-important', $task).removeClass('md-jellow').addClass('md-dark md-inactive')
        when 'deletedeadline'
            $('ul.menu-information li.ms-deadline', $task).removeClass('active')
            if  !($('#menu >ul.menu-option li i.i-btn-datepicker', $task).hasClass('md-dark md-inactive'))
              $('#menu >ul.menu-option li i.i-btn-datepicker', $task).addClass('md-dark md-inactive').removeClass('md-red')
            $('p#alternate', $task).html('')
        when 'deadline'
          if (data.deadline != "") || (data.deadline != "null")
            # d = new Date(data.deadline)
            # date = d.getShortDayWeek()+ ', ' + d.getDate() + ' ' + d.getShortMonth()
            $('ul.menu-information li.ms-deadline', $task).addClass('active')
            if  $('#menu >ul.menu-option li i.i-btn-datepicker', $task).hasClass('md-dark md-inactive')
              $('#menu >ul.menu-option li i.i-btn-datepicker', $task).removeClass('md-dark md-inactive').addClass('md-red')
            $('p#alternate', $task).html(data.deadline)
        when 'changelist'
          $("#task_"+ data.id + " #menu .tooltipped").tooltip('remove')
          if (data.list_all_task_id != $currentListMainCenter)
            $task.remove()
          else
            $task.replaceWith data.html
            $('.edit_task').submitOnCheck()
          if (data.num != '')
            $('.bar-number-task', $listNav).html data['num']
            $('.bar-number-task', $listChangeNav).html data['num_list_change']
        when 'completed'
          $("#task_"+ data.id + " #menu .tooltipped", $incomplete ).tooltip('remove')
          $task.remove()
          if ($('[data-date = "0"]', $divCompleted).length == 0)
            $divCompleted.prepend '<div class="line-behind" data-date="0">Today</div>'
          $insertCompleted = $('[data-date = "0"]', $divCompleted)
          $( data['html'] ).insertAfter $insertCompleted
          # $insertCompleted.insertAfter data['html']
          $('.tooltipped').tooltip({delay: 50})
          if ($('.divider', $user).hasClass('no-active'))
            $('.divider', $user).removeClass('no-active')
          if (data.num != '')
            $('.bar-number-task', $listNav).html data['num']
            $('.bar-number-task', $listAllTaskNav).html data['numAllTask']
          $('.edit_task').submitOnCheck()
        when 'incomplete'
          $("#task_"+ data.id + " #menu .tooltipped", $divCompleted ).tooltip('remove')
          $task.remove()
          $incomplete.prepend data['html']
          $lineDate = $('[data-date = "'+ data.num_date+'"]', $divCompleted)
          if ((data['num_completed_tasks_date'] == 0) && ($lineDate.length != 0))
            $lineDate.remove()
          if (data.num != '')
            $('.bar-number-task', $listNav).html data['num']
            $('.bar-number-task', $listAllTaskNav).html data['numAllTask']
          $('.edit_task').submitOnCheck()

      deadlineDatepicker($('input.deadline-datepicker',$list ))
    else
      if data.blocker
          $parent = $('[data-task-id = "' + data.parentId + '"]', $user)
          $('#show_blockers_' + data.parentId).prepend data['html']
          $('.tooltipped').tooltip({delay: 50})
          if !($('a#link-blocker > i',$parent).hasClass('md-red'))
            $('a#link-blocker > i',$parent).addClass('md-red')
            $('a#link-blocker > i',$parent).removeClass('md-inactive')
          $('i[data-has-blockers]',$parent).data('data-has-blockers','true')
          $('.edit_task').submitOnCheck()

      else
        $incomplete.prepend data['html']
        $('.tooltipped').tooltip({delay: 50})
        $('.edit_task').submitOnCheck()
        $('#list_user_' + data['user'] + ' .new_task #task_detail').val('');
        if (data.num != '')
          $('.bar-number-task', $listNav).html data['num']
          $('.bar-number-task', $listAllTaskNav).html data['numAllTask']

  submit_task = () ->
  $('#new_task #detail').on 'keydown', (event) ->
    if event.keyCode is 13
      $('#new_task #create_task_button').click()
      event.target.value = ""
      event.preventDefault()
