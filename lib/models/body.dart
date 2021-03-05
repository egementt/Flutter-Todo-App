class Body {
	int id;
	String name;
	String date;
	int userId;
	int isActive;

	Body({
		this.id,
		this.name,
		this.date,
		this.userId,
		this.isActive,
	});

	@override
	String toString() {
		return 'Body(id: $id, name: $name, date: $date, userId: $userId, isActive: $isActive)';
	}

	factory Body.fromJson(Map<String, dynamic> json) {
		return Body(
			id: json['id'] as int,
			name: json['name'] as String,
			date: json['date'] as String,
			userId: json['userId'] as int,
			isActive: json['isActive'] as int,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'date': date,
			'userId': userId,
			'isActive': isActive,
		};
	}
}
