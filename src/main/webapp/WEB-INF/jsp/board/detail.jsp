<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>
    <title>JPA</title>
    <!-- Favicon-->
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <link rel="stylesheet" href="<c:url value="/css/bootstrap.min.css" />">
</head>
<body>

<jsp:include page="../navigation.jsp" flush="false"/>

<!-- Page Content -->
<sec:csrfMetaTags/>
<div class="container mt-5">
    <div class="row">
        <div class="col-lg-8">
            <!-- Post content-->
            <article>
                <!-- Post header-->
                <header class="mb-4">
                    <!-- Post title-->
                    <h1 class="fw-bolder mb-1" id="boardTitle">${board.boardTitle}</h1>
                    <!-- Post meta content-->
                    <div class="text-muted fst-italic mb-2">Posted on ${board.regDate}</div>
                    <!-- Post categories-->
                    <a class="badge bg-secondary text-decoration-none link-light" id="categoryNm"></a>
                </header>
                <!-- Preview image figure-->
                <figure class="mb-4">
                    <img class="img-fluid rounded" src="https://dummyimage.com/900x400/ced4da/6c757d.jpg" alt="..."/>
                </figure>
                <!-- Post content-->
                <section class="mb-5">
                    <p id="boardContent">${board.boardContent}</p>
                </section>
            </article>

            <!-- Comments section-->
            <section class="mb-5">
                <div class="card bg-light">
                    <div class="card-body" id="bodyCmmt">
                        <!-- Comment form-->
                        <div class="input-group"><textarea class="form-control" rows="1" placeholder="댓글을 남겨주세요" id="cmmtContent"></textarea>
                            <button type="button" class="btn btn-outline-secondary" id="btnRegCmmt">Submit</button>
                        </div><br>
                        <!-- Comment with nested comments-->
                        <c:forEach var="comments" items="${comments}" varStatus="status">
                        <div class="d-flex mb-4">
                            <!-- Parent comment-->
                            <div class="flex-shrink-0"><img class="rounded-circle" src="https://dummyimage.com/50x50/ced4da/6c757d.jpg" alt="..."/></div>
                            <div class="ms-3">
                                <div class="fw-bold">${comments.memberName}</div>
                                ${comments.commentContent}
                            </div>
                        </div>
                        </c:forEach>
                        <!-- Comment with nested comments-->
<%--                        <div class="d-flex mb-4">--%>
<%--                            <!-- Parent comment-->--%>
<%--                            <div class="flex-shrink-0"><img class="rounded-circle" src="https://dummyimage.com/50x50/ced4da/6c757d.jpg" alt="..."/></div>--%>
<%--                            <div class="ms-3">--%>
<%--                                <div class="fw-bold">Commenter Name</div>--%>
<%--                                If you're going to lead a space frontier, it has to be government; it'll never be--%>
<%--                                private enterprise. Because the space frontier is dangerous, and it's expensive, and it--%>
<%--                                has unquantified risks.--%>
<%--                                <!-- Child comment 1-->--%>
<%--                            </div>--%>
<%--                        </div>--%>
                    </div>
                </div>
            </section>
        </div>
        <!-- Side widgets-->
        <jsp:include page="../side.jsp" flush="false"/>
    </div>
</div>

<jsp:include page="../footer.jsp" flush="false"/>

</body>

<!-- Bootstrap core JavaScript -->
<script type="text/javascript" src="<c:url value="/js/jquery-1.12.4.js"/> "></script>
<script type="text/javascript" src="<c:url value="/js/common.js"/> "></script>
<script type="text/javascript" src="<c:url value="/js/board.js"/> "></script>
<script type="text/javascript">
    $(document).ready(function () {
        let boardNo = ${boardNo};

        // 수정 버튼
        $('#btnBoardEdit').on('click', function () {
            location.href = '/board/edit/' + boardNo;
        });

        // 삭제 버튼
        $('#btnBoardDelete').on({
            click: function () {
                if (confirm('삭제하시겠습니까?') == true) {
                    $.ajax({
                        url: baseUrl + '/api/board/delete/' + boardNo,
                        type: 'GET',
                        success: function (result) {
                            location.href = '/member';
                        }, error: function (error) {
                            console.log('error');
                        }
                    })
                }
            }
        })

        // 댓글
        /*
        $.ajax({
            url: baseUrl + '/api/comment/list/' + boardNo,
            type: 'GET',
            dataType: 'json',
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function (result) {
                console.log(result)
                // $('#cmmtCnt').text(result.data.commentCnt);

                $.each(result.data.commentList, function (key, obj) {
                    $('#bodyCmmt').append($('<br />')).append($('<div />', {
                        class: 'd-flex'
                    }).append($('<div />', {
                        class: 'flex-shrink-0'
                    }).append($('<img />', {
                        class: 'rounded-circle',
                        src: 'https://dummyimage.com/50x50/ced4da/6c757d.jpg',
                        alt: '...'
                    }))).append($('<div />', {
                        class: 'ms-3'
                    }).append($('<div />', {
                        class: 'fw-bold',
                        text: obj.memberId
                    })).append(obj.commentContent)));
                })
            }, error: function (error) {
                console.log('error');
            }
        })
        */

        // 댓글 등록 버튼
        /*
        $('#btnRegCmmt').on({
            click: function () {
                if (confirm('댓글을 등록하시겠습니까?') == true) {
                    $.ajax({
                        url: baseUrl + '/api/comment/register',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            'boardNo': boardNo,
                            'commentContent': $('#cmmtContent').val()
                        }),
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                        },
                        success: function (result) {
                            location.reload();
                        }, error: function (error) {
                            console.log(error);
                        }
                    })
                }
            }
        })*/
    });
</script>

</html>
