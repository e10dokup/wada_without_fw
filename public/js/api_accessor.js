function getPassing() {
    var user = $('#search [name=name]').val();
    var date = $('#search [name=date]').val();
    var times = $('#search [name=times]').val();
    var passed_with = $('#search [name=with]').val();

    $.ajax({
        type: "get",
        url: "/api/passby",
        contentType: 'application/json',
        data: {
            user: user,
            date: date,
            times: times,
            passed_with: passed_with
        },
        dataType: 'json',
        success: function(json_data) {
            $("#table tbody *").remove();
            $.each(json_data, function(i) {
                $("#table").prepend('<tr><td>' + json_data[i].time + '</td><td>' + json_data[i].subject + '</td></tr>');
            })
        },
        error: function() {
            alert("Server error.");
        }
    })
}

function createUser() {
    var name = $('#create_user [name=uid]').val();
    var kind = $('#create_user [name=kind]').val();
    var uid = $('#create_user [name=id]').val();
    var ble_uid = "";
    var wifi_uid = "";
    
    if(kind == "ble") {
        ble_uid = uid;
    } else if(kind == "wifi") {
        wifi_uid = uid;
    }

    var data = {
        name: name,
        ble_uid: ble_uid,
        wifi_uid: wifi_uid
    };

    $.ajax({
        type: "post",
        url: "/api/user/create",
        data: JSON.stringify(data),
        contentType: 'application/json',
        dataType: 'json',
        success: function(json_data) {
            location.reload();
        },
        error: function() {
            alert("Server error.");
        }
    });
}

function createPassings() {
    var input = document.getElementById("file");

    var reader = new FileReader();
    reader.onload = function (event) {
        data = postPassingCsv(event.target.result);

        $.ajax({
            type: "post",
            url: "/api/passby/create_multi",
            data: JSON.stringify(data),
            contentType: 'application/json',
            dataType: 'json',
            success: function(json_data) {
                location.reload();
            },
            error: function() {
                alert("Server error.");
            }
        });
    };
    reader.readAsText(input.files[0], "utf-8");
}

function postPassingCsv(csv) {
    var csvArray = csv.split('\n');
    var columns = ['passing_at', 'object_address', 'subject_address'];
    var jsonArray = [];
    for (var i=0; i<csvArray.length - 1; i++) {
        var json = new Object();
        var csvRow = csvArray[i].split(',');
        for(var j=0; j<columns.length; j++) {
            json[columns[j]] = csvRow[j];
        }
        jsonArray.push(json);
    }
    console.log(jsonArray);
    return jsonArray;
}

