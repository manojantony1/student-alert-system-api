"SELECT 
		CONVERT(VARCHAR(50),a_id) PrimaryKey, 
		a_id Id, 
		CONVERT(VARCHAR(50),a_object_id) StudentLink, 
		(
			SELECT vc_name
			FROM caps_valid_codes WITH (nolock)
			WHERE vc_domain = 'alert'
			AND vc_code = a_type
		) Type,
		a_start 'Start', 
		a_end 'End', 
		a_details Alert
	FROM 
		caps_alerts WITH (nolock)
	WHERE 
		a_object_id = $(vars.studentId)
		AND EXISTS (SELECT NULL FROM capd_student WHERE s_id = a_object_id)
		AND ISNULL(a_end, DATEADD(day,1,GETDATE())) > GETDATE()
		AND ISNULL(a_start, DATEADD(day,-1,GETDATE())) < GETDATE()
	AND a_details IS NOT NULL"