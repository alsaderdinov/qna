$(document).on('turbolinks:load', function () {
	$('.vote').on('ajax:success', function (e) {
		const rating = e.detail[0]['rating'],
			resource = e.detail[0]['resource'],
			id = e.detail[0]['id']

		$(`#vote-${resource}_${id} .vote-rating`).html(`Rating: ${rating}`)
	})
});
