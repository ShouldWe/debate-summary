#
# Debate Summary - Croudsource arguments and debates
# Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
#
# This file is part of Debate Summary.
#
# Debate Summary is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Debate Summary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
#
class ProposedEditsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def index
    @proposed_edit = ProposedEdit.all
  end
  def show
    @proposed_edit = ProposedEdit.find params[:id]
    @issue = @proposed_edit.issue
    @CD = @proposed_edit
  end

  def accept
    @proposed_edit = ProposedEdit.find params[:id]
    @proposed_edit.accept!
    flash[:notice] = "Edit accepted"
    redirect_to history_issue_path(@proposed_edit.issue)
  end

  def reject
    @proposed_edit = ProposedEdit.find params[:id]
    @proposed_edit.reject!
    flash[:notice] = "Edit rejected"
    redirect_to history_issue_path(@proposed_edit.issue)
  end
end