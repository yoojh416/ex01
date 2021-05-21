package org.jihyeong.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
/*import org.apache.ibatis.annotations.Select;*/
import org.jihyeong.domain.BoardVO;
import org.jihyeong.domain.Criteria;

public interface BoardMapper {
	/* @Select("select * from tbl_board where bno>0") */
	/* 어노테이션 방식이 아니라 Mapper.xml에서 기능 구현해서 사용할 것임 */
	public List<BoardVO> getList();
	public List<BoardVO> getListWithPaging(Criteria cri);
	public void insert(BoardVO board);
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);

	public int update(BoardVO board);
	
	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
