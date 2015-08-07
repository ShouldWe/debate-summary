/*
 * Debate Summary - Croudsource arguments and debates
 * Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
 *
 * This file is part of Debate Summary.
 *
 * Debate Summary is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Debate Summary is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
 */

/*jshint browser:true, jquery:true */
/*global bootbox:true */
(function($,bootbox){
  "use strict";
  var addNewArgument, openAreaSection;
  $(document).ready(function(){
    $(this).trigger('newAssignment');
  });

  addNewArgument = function(){
    var $holder,$elm,regexp,time;
    $holder = $(this).parent().parent().find('.area-content').last();
    $elm = $holder.clone();
    $elm.find(':input').removeAttr('value');
    $elm.find('[contenteditable]').html("");
    $elm.removeClass('open');
    regexp = new RegExp($elm.data('id'), 'g');
    time = new Date().getTime();
    $holder.after($elm[0].outerHTML.replace(regexp,time));
    $elm.find(".area-title-input").focus();
    $('html,body').stop(true,true).delay(600).animate({
      scrollTop: $holder.offset().top
    },250,'swing');
    $(document).trigger('newAssignment');
  };

  openAreaSection = function(){
    var $container, $parent;
    $container = $(this).parents('.area-box');
    $parent = $(this).parents(".area-content");
    if($(this).is(":not(:input)") && $container.hasClass('open') && $parent.hasClass('open')){
      $('.area-box.open').removeClass('open');
      $parent.removeClass('open');
    }else if($container.hasClass('open') && !$parent.hasClass('open')){
      $container.find('.area-content.open').removeClass('open');
      $parent.addClass('open');
    }else{
      $('.area-box.open').removeClass('open');
      $('.area-content.open').removeClass('open');
      $container.addClass('open');
      $parent.removeClass('open');
      $parent.addClass('open');
    }
    setTimeout(function(){
      $(document).trigger('newAssignment');
    },550);
  };


  $(document).on("click",".delete-argument",function(){
    var $this;
    $this = $(this);
    bootbox.animate(false); // something somewhere causes modal's to fail
    bootbox.confirm("Are you sure you would like to remove this argument?","No","Yes",function(result){
      if(result){
        if($this.parents('.area-container').find('.area-content').length > 1){
          $this.parents('.area-content').remove();
          $(document).trigger('newAssignment');
        }else{
          var $elm = $this.parents('.area-content');
          $elm.find(':input').val("");
          $elm.find('[contenteditable]').html("");
        }
      }
    });
  });

  $(document).on('newAssignment',function(){
    $('.area-boxes').each(function(){
      var $this = $(this), newHeight = 0;
      $.each($this.children(), function(){
        if($(this).height() > newHeight){
          newHeight = $(this).outerHeight();
        }
      });
      $this.height(newHeight);
    });
  });

  $(document).on("click",".new-argument",addNewArgument);
  $(document).on('click',".area-arrow",openAreaSection);
  $(document).on('focus',".area-content :input",openAreaSection);

})(jQuery,bootbox);
