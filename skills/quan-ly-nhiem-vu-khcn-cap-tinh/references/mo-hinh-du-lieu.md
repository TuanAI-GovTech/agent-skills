# Mô hình dữ liệu quản lý

Chỉ dùng các trường cần cho yêu cầu hiện tại. Với bảng tính, mỗi hàng biểu diễn một nhiệm vụ và dùng bảng phụ cho mốc, sản phẩm, kinh phí, hồ sơ và lịch sử thay đổi khi một ô không đủ biểu diễn.

## Bảng nhiệm vụ

### Nhận diện

- `ma_nhiem_vu`: khóa duy nhất; mã tạm phải có nhãn.
- `ten_nhiem_vu`, `ten_rut_gon`, `linh_vuc`, `loai_nhiem_vu`.
- `tinh_thanh`, `nam_danh_muc`, `ky_bao_cao`.
- `co_quan_quan_ly`, `don_vi_chu_tri`, `chu_nhiem`, `don_vi_phoi_hop`.

### Pháp lý và hợp đồng

- `quyet_dinh_danh_muc`, `quyet_dinh_phe_duyet`, `hop_dong`, `phu_luc`.
- Mỗi tham chiếu nên có số, ngày, cơ quan ban hành, phiên bản hoặc liên kết nguồn.
- `ngay_bat_dau`, `ngay_ket_thuc_goc`, `ngay_ket_thuc_duoc_duyet`.

### Trạng thái

Dùng một giá trị chính và thêm trường chi tiết khi cần:

`Đề xuất` → `Trong danh mục` → `Tuyển chọn/Giao trực tiếp` → `Hoàn thiện hồ sơ` → `Đã ký hợp đồng` → `Đang thực hiện` → `Tạm dừng` hoặc `Đề nghị điều chỉnh` → `Chuẩn bị nghiệm thu` → `Đã họp nghiệm thu` → `Hoàn thiện sau nghiệm thu` → `Đã công nhận/hoàn tất` → `Theo dõi ứng dụng` → `Đóng hồ sơ`.

Không thay thế trạng thái chính thức bằng trạng thái suy ra. Có thể thêm `trang_thai_suy_ra` và `ly_do_suy_ra` để cảnh báo.

### Tiến độ và sản phẩm

- `tien_do_ke_hoach_pct`, `tien_do_bao_cao_pct`, `tien_do_xac_minh_pct`.
- `moc_ke_tiep`, `han_moc_ke_tiep`, `so_ngay_con_lai`.
- `san_pham_cam_ket`, `san_pham_da_nop`, `san_pham_dat`, `bang_chung_san_pham`.

Không trộn tỷ lệ tự báo cáo và tỷ lệ đã xác minh. Tỷ lệ thời gian tham khảo:

`min(100%, max(0%, (ngày báo cáo - ngày bắt đầu) / (ngày kết thúc được duyệt - ngày bắt đầu)))`.

Chỉ tính khi đủ ba ngày hợp lệ; nếu không, trả về `chưa tính được`.

### Kinh phí

- `tong_kinh_phi`, `ngan_sach_snkh`, `nguon_khac`.
- `kinh_phi_da_cap`, `kinh_phi_da_chi`, `kinh_phi_da_quyet_toan`.
- `ty_le_giai_ngan`, `chenh_lech_tong`, `don_vi_tien`, `ky_so_lieu`.

Kiểm tra tối thiểu:

- `tong_kinh_phi = ngan_sach_snkh + nguon_khac` khi mô hình nguồn chỉ gồm hai nhóm;
- `kinh_phi_da_chi <= kinh_phi_da_cap` trừ khi có giải thích và nguồn khác;
- tỷ lệ giải ngân ghi rõ mẫu số là tổng kinh phí, kinh phí được cấp hay dự toán kỳ.

Không tự làm tròn để che sai lệch. Nêu ngưỡng sai số nếu nguồn có quy tắc làm tròn.

### Quản trị

- `muc_canh_bao`, `ly_do_canh_bao`, `rui_ro`, `hanh_dong_tiep_theo`.
- `don_vi_phu_trach`, `nguoi_phu_trach`, `han_xu_ly`.
- `nguon_du_lieu`, `ngay_cap_nhat`, `nguoi_cap_nhat`, `muc_xac_minh`.
- `ghi_chu`, `thong_tin_can_bo_sung`.

## Các bảng phụ

- `Moc`: mã nhiệm vụ, tên mốc, loại mốc, hạn gốc, hạn được duyệt, ngày hoàn thành, trạng thái, bằng chứng.
- `San_pham`: mã nhiệm vụ, mã sản phẩm, tên, số lượng, tiêu chí chất lượng, hạn, kết quả, bằng chứng.
- `Kinh_phi`: mã nhiệm vụ, kỳ, nguồn, khoản mục, dự toán, được cấp, đã chi, quyết toán, nguồn chứng từ.
- `Ho_so`: mã nhiệm vụ, giai đoạn, tên tài liệu, bắt buộc hay tham khảo, phiên bản, ngày, trạng thái, vị trí tệp.
- `Thay_doi`: mã nhiệm vụ, trường thay đổi, giá trị cũ, giá trị đề xuất, giá trị được duyệt, căn cứ, ngày hiệu lực.
- `Rui_ro_hanh_dong`: mã nhiệm vụ, rủi ro hoặc vấn đề, mức độ, hành động, chủ trì, hạn, trạng thái, bằng chứng đóng.

## Quy tắc chất lượng dữ liệu

- Chuẩn hóa ngày nội bộ theo `YYYY-MM-DD`, nhưng giữ cách hiển thị của biểu mẫu chính thức.
- Ghi đơn vị tiền và đơn vị đo ở cấp cột hoặc từng giá trị nếu không đồng nhất.
- Không gộp ô trong vùng dữ liệu máy đọc; không dùng màu làm nguồn thông tin duy nhất.
- Phát hiện mã trùng, ngày kết thúc trước ngày bắt đầu, tỷ lệ ngoài 0–100%, số âm bất thường và liên kết nguồn bị thiếu.
- Mọi giá trị chuẩn hóa khác dữ liệu gốc phải truy vết được đến quy tắc hoặc người phê duyệt.

