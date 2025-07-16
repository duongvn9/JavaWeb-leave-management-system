<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agenda nghỉ phép cá nhân</title>
    <style>
        body {
            background: #f8fafc;
        }
        .agenda-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px 0 0 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .date-form {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            background: #f7fafd;
            border-radius: 12px;
            padding: 1.2rem 2.2rem;
            margin-bottom: 22px;
            box-shadow: 0 2px 12px rgba(66,133,244,0.08);
            max-width: 600px;
            min-width: 350px;
        }
        .week-btn-group {
            display: flex;
            gap: 0.7rem;
            margin-bottom: 18px;
            justify-content: center;
        }
        .agenda-legend {
            display: flex;
            align-items: center;
            gap: 2.2rem;
            margin-bottom: 18px;
            margin-top: 10px;
            justify-content: center;
        }
        .agenda-table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 24px;
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(66,133,244,0.07);
            overflow: hidden;
        }
        .agenda-table th, .agenda-table td {
            border: 2px solid #bdbdbd;
            padding: 12px 10px;
            text-align: center;
            font-size: 1.05rem;
        }
        .agenda-table th {
            background: #f5f5f5;
            font-weight: 700;
            font-size: 1.08rem;
        }
        .agenda-working { background: #a8e6a3; }
        .agenda-leave { background: #ff6b6b; }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1rem;
        }
        .legend-color {
            width: 22px;
            height: 22px;
            border-radius: 5px;
            display: inline-block;
            border: 1.5px solid #bbb;
        }
        .date-form input[type="text"], .date-form input[type="date"] {
            border: 2px solid #4285F4;
            border-radius: 8px;
            padding: 0.55rem 2.2rem 0.55rem 1rem;
            font-size: 1.08rem;
            background: #fff url('https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css') no-repeat right 0.8rem center/1.3em auto;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
            min-width: 140px;
            box-sizing: border-box;
        }
        .date-form input[type="text"]:focus, .date-form input[type="date"]:focus {
            border-color: #34a853;
            box-shadow: 0 0 0 2px #a8e6a3;
        }
        .date-form label {
            font-weight: 500;
            color: #232946;
            margin-bottom: 0;
            display: flex;
            align-items: center;
        }
        .date-form button, .week-btn {
            background: linear-gradient(135deg, #4285F4 0%, #34a853 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 0.45rem 1.2rem;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s;
            margin-left: 0.2rem;
        }
        .date-form button:hover, .week-btn:hover {
            background: linear-gradient(135deg, #357ae8 0%, #2e7d32 100%);
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/material_blue.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        function parseDMY(str) {
            if (!str) return null;
            var parts = str.split('/');
            if (parts.length === 3) {
                return new Date(parts[2], parts[1] - 1, parts[0]);
            }
            parts = str.split('-');
            if (parts.length === 3) {
                return new Date(parts[0], parts[1] - 1, parts[2]);
            }
            return null;
        }
        function formatDMY(date) {
            if (!date) return '';
            let d = date.getDate();
            let m = date.getMonth() + 1;
            let y = date.getFullYear();
            return (d < 10 ? '0' : '') + d + '/' + (m < 10 ? '0' : '') + m + '/' + y;
        }
        function changeWeek(offset) {
            const from = document.getElementById('from');
            const to = document.getElementById('to');
            let fromDate = parseDMY(from.value) || new Date();
            let toDate = parseDMY(to.value) || new Date();
            if (!from.value || !to.value) {
                const today = new Date();
                const day = today.getDay() || 7;
                fromDate = new Date(today);
                fromDate.setDate(today.getDate() - day + 1);
                toDate = new Date(fromDate);
                toDate.setDate(fromDate.getDate() + 6);
            }
            fromDate.setDate(fromDate.getDate() + offset * 7);
            toDate.setDate(toDate.getDate() + offset * 7);
            from.value = formatDMY(fromDate);
            to.value = formatDMY(toDate);
            from.form.submit();
        }
        function goToCurrentWeek() {
            const today = new Date();
            const day = today.getDay() || 7;
            const fromDate = new Date(today);
            fromDate.setDate(today.getDate() - day + 1);
            const toDate = new Date(fromDate);
            toDate.setDate(fromDate.getDate() + 6);
            document.getElementById('from').value = formatDMY(fromDate);
            document.getElementById('to').value = formatDMY(toDate);
            document.getElementById('from').form.submit();
        }
        window.addEventListener('DOMContentLoaded', function() {
            flatpickr("#from", {
                dateFormat: "d/m/Y",
                allowInput: true,
                defaultDate: document.getElementById('from').value ? document.getElementById('from').value.split('-').reverse().join('/') : null
            });
            flatpickr("#to", {
                dateFormat: "d/m/Y",
                allowInput: true,
                defaultDate: document.getElementById('to').value ? document.getElementById('to').value.split('-').reverse().join('/') : null
            });
            document.querySelector('.date-form').addEventListener('submit', function(e) {
                var from = document.getElementById('from');
                var to = document.getElementById('to');
                if (from.value) {
                    var parts = from.value.split('/');
                    if (parts.length === 3) {
                        from.value = parts[2] + '-' + parts[1].padStart(2,'0') + '-' + parts[0].padStart(2,'0');
                    }
                }
                if (to.value) {
                    var parts = to.value.split('/');
                    if (parts.length === 3) {
                        to.value = parts[2] + '-' + parts[1].padStart(2,'0') + '-' + parts[0].padStart(2,'0');
                    }
                }
            });
        });
    </script>
</head>
<body>
    <div class="agenda-container">
        <form method="get" class="date-form">
            <label for="from">Từ ngày:</label>
            <input type="text" id="from" name="from" value="${param.from}" autocomplete="off" placeholder="dd/MM/yyyy">
            <label for="to">Đến ngày:</label>
            <input type="text" id="to" name="to" value="${param.to}" autocomplete="off" placeholder="dd/MM/yyyy">
            <button type="submit">Xem</button>
        </form>
        <div class="week-btn-group">
            <button type="button" class="week-btn" onclick="changeWeek(-1)">← Tuần trước</button>
            <button type="button" class="week-btn" onclick="changeWeek(1)">Tuần sau →</button>
            <button type="button" class="week-btn" onclick="goToCurrentWeek()">Tuần hiện tại</button>
        </div>
        <div class="agenda-legend">
            <div class="legend-item"><span class="legend-color agenda-working"></span> Đi làm</div>
            <div class="legend-item"><span class="legend-color agenda-leave"></span> Nghỉ phép</div>
        </div>
        <c:if test="${not empty users && not empty days}">
            <table class="agenda-table">
                <tr>
                    <th>Nhân sự</th>
                    <c:forEach var="dStr" items="${daysStr}">
                        <th><b>${fn:substring(dStr,0,5)}</b></th>
                    </c:forEach>
                </tr>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.fullName} (ID: ${u.id})</td>
                        <c:forEach var="d" items="${days}">
                            <c:set var="status" value="${agendaMap[u.id][d]}" />
                            <td class="${status == 'ON_LEAVE' ? 'agenda-leave' : 'agenda-working'}">
                                <!-- chỉ để màu, không có chữ -->
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
        <p style="color: #888; margin-top: 16px; text-align:center;">(Bảng agenda sẽ được hiển thị tự động theo dữ liệu thực tế.)</p>
    </div>
</body>
</html> 