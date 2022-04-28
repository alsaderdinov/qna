import consumer from "./consumer"

$(document).on('turbolinks:load', () => {
	const questionID = $('.question').data('question-id')

	consumer.subscriptions.create("AnswersChannel", {
		connected() {
			this.perform('follow', {question_id: questionID})
		},

		received(data) {
			if (gon.user_id !== data.answer_user_id)
				$('.answers-list').append(data.answer)

			if (gon.user_id) {
				$(`#vote-answer_${data.answer_id} .vote-buttons`).removeClass('d-none')
			}

			if (gon.user_id === data.question_user_id) {
				$(`#best-answer_${data.answer_id} .best-answer-link`).removeClass('d-none')
			}
		}
	});
})
