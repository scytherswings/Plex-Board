# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link)
  false

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  html = """
         <div class="modal" id="confirmationDialog">
           <div class="modal-dialog">
             <div class="modal-content">
               <div class="modal-header">
                 <a class="close" data-dismiss="modal">×</a>
                 <h3>#{message}</h3>
               </div>
               <div class="modal-footer">
                 <a data-dismiss="modal" class="btn">Cancel</a>
                 <a data-dismiss="modal" class="btn btn-primary confirm">OK</a>
               </div>
             </div>
           </div>
         </div>
         """
  $(html).modal()
  $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)