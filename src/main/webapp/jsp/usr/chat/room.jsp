<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../common/head.jspf"%>

<script>
function ChatRoomSave__submitForm(form) {
    form.title.value = form.title.value.trim();

    if ( form.title.value.length == 0 ) {
        alert('제목을 입력해주세요.');
        form.title.focus();
        return;
    }

    form.body.value = form.body.value.trim();

    if ( form.body.value.length == 0 ) {
        alert('내용을 입력해주세요.');
        form.body.focus();
        return;
    }

    form.submit();
}
</script>

<section>
    <div class="container px-3 mx-auto">
        <h1 class="font-bold text-lg">채팅방</h1>

        <div>
            ${room.title}
        </div>

        <div>
            ${room.body}
        </div>

        <script>
        function ChatMessageSave__submitForm(form) {
            form.body.value = form.body.value.trim();

            if ( form.body.value.length == 0 ) {
                form.body.focus();

                return false;
            }

            form.submit();
        }
        </script>

        <form onsubmit="ChatMessageSave__submitForm(this); return false;" method="POST" action="/usr/chat/writeMessage/${room.id}">
            <input autofocus name="body" type="text" placeholder="메세지를 입력해주세요." class="input input-bordered" />
            <button type="submit" value="" class="btn btn-outline btn-primary">
                작성
            </button>
        </form>

        <ul class="mt-5">
            <!-- 이 부분에 동적으로(자바스크립트로) 엘리먼트를 만들어서 넣어준다. -->
            <!-- 필요한 데이터는 ajax로 불러온다. -->
            <!-- /usr/chat/getMessages/10 => JSON으로 채팅메세지 제공 -->
        </ul>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>