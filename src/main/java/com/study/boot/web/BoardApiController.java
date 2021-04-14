package com.study.boot.web;

import com.study.boot.board.domain.Category;
import com.study.boot.board.service.BoardService;
import com.study.boot.board.service.CategoryService;
import com.study.boot.member.domain.Member;
import com.study.boot.member.service.MemberService;
import com.study.boot.payload.request.BoardRequest;
import com.study.boot.payload.response.ApiResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/api/board")
public class BoardApiController {

    private final BoardService boardService;
    private final MemberService memberService;
    private final CategoryService categoryService;

    @GetMapping("list")
    public ResponseEntity<?> boardListAll() throws Exception {

        ApiResponse apiResponse = new ApiResponse(true, "게시물 전체 조회");
        apiResponse.putData("boardList", boardService.findAllBoard());

        return ResponseEntity.ok(apiResponse);
    }

    @PostMapping("register")
    public ResponseEntity<?> boardRegister(@Validated @RequestBody BoardRequest boardRequest, Authentication authentication) throws Exception {

        Member member = memberService.loadUserByUsername(authentication.getPrincipal().toString());
        Category category = categoryService.findByCategoryNo(boardRequest.getCategoryNo());
        boardService.registerBoard(boardRequest, member, category);

        ApiResponse apiResponse = new ApiResponse(true, "게시물 등록");

        return ResponseEntity.ok(apiResponse);
    }

    @GetMapping("info/{boardNo}")
    public ResponseEntity<?> boardDetailInfo(@PathVariable(name = "boardNo") Long boardNo) throws Exception{

        ApiResponse apiResponse = new ApiResponse(true, "게시물 상세정보 조회");
        apiResponse.putData("boardInfo", boardService.findBoardByNo(boardNo));

        return ResponseEntity.ok(apiResponse);
    }

    @PostMapping("edit/{boardNo}")
    public ResponseEntity<?> boardEdit(@Validated @PathVariable(name = "boardNo") Long boardNo, @RequestBody BoardRequest boardRequest) throws Exception {

        boardService.updateBoard(boardRequest, boardNo);
        ApiResponse apiResponse = new ApiResponse(true, "게시물 수정");

        return ResponseEntity.ok(apiResponse);
    }

    @GetMapping("delete/{boardNo}")
    public ResponseEntity<?> boardDelete(@PathVariable(name = "boardNo") Long boardNo) throws Exception {

        boardService.deleteByNo(boardNo);
        ApiResponse apiResponse = new ApiResponse(true, "게시물 삭제");

        return ResponseEntity.ok(apiResponse);
    }
}
