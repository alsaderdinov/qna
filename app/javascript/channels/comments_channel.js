import consumer from "./consumer"

$(document).on('turbolinks:load', () => {
	consumer.subscriptions.create("CommentsChannel", {
		connected() {
			this.perform('follow')
		},

		received(data) {
			console.log(data)
			if(gon.user_id === data.user_id)
			$(`.${data.commentable_type}-comments`).append(data.comment)
		}
	});
})
