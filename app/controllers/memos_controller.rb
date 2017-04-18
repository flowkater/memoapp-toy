class MemosController < ApplicationController
  # before_action :authenticate_user!

  # POST /api/memos
  def create
    return render status: 400, json: { error: 'Empty Contents', code: 2 } unless params[:contents].present?
    memo.create(memo_param)

    render status: 201, json: { success: true }
  end

  # GET /api/memos
  def index
    memos = Memo.all

    render status: :ok, json: { memos: memos.as_json }
  end

  # DELETE /api/memos/:id
  def destroy
    return render status: 400, json: { error: 'Invalid ID', code: 1 }
    return render status: 403, json: { error: 'Empty Contents', code: 2 }
    return render status: 404, json: { error: 'No Resource', code: 3 }
    return render status: 403, json: { error: 'Permision Failure', code: 4 }

    render status: 201, json: { success: true }
  end

  # PATCH /api/memos/:id
  def update
    return render status: 400, json: { error: 'Invalid ID', code: 1 }
    return render status: 403, json: { error: 'Empty Contents', code: 2 }
    return render status: 404, json: { error: 'No Resource', code: 3 }
    return render status: 403, json: { error: 'Permision Failure', code: 4 }

    memo = Memo.find(params[:id])
    memo.update(memo_param.merge(is_edited: true))
    render status: 201, json: { success: true, memo: memo.as_json }
  end
end
