<template>
<div class="row">
    <div class="col-md-6">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">Danh sách người dùng <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Cập nhật người dùng </h4>
    </div>
</div>
<div class="card">
    <div class="row">
        <div class="col-md-9">
            <div class="card-body">
                <form>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="username">Tên nhân viên</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="user.display_name" id="display_name" placeholder="Nhâp tên nhân viên" />
                            <small class="text-danger text-start-center" v-if="errors.display_name">{{ errors.display_name[0]
                        }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="email">Email</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="user.email" id="email" placeholder="Nhập email khách hàng ( ví dụ: abc@gmail.com )" />
                            <small class="text-danger text-start-center" v-if="errors.email">{{ errors.email[0]
                        }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="phone">Số điện thoại</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" v-model="user.phone" id="phone" placeholder="012345678" />
                            <small class="text-danger text-start-center" v-if="errors.phone">{{ errors.phone[0]
                        }}</small>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Khu vực</label>
                        <div class="col-sm-10">
                            <model-list-select :list="stores" v-model="user.store_id" option-value="ID" option-text="store_name" placeholder="Chọn khu vực"></model-list-select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="exampleFormControlSelect1" class="col-sm-2 col-form-label">Nhóm quyền</label>
                        <div class="col-sm-10">
                            <model-list-select :list="roles" v-model="userRoles" option-value="id" option-text="name" placeholder="Chọn nhóm quyền"></model-list-select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-sm-2 col-form-label" for="username">Hoạt động</label>
                        <div class="col-sm-10">
                            <input type="checkbox" class="form-check-input mt-2" v-model="isActive" />
                        </div>
                    </div>
                </form>
                <div class="modal-footer mt-3">
                    
                    <button type="button" class="btn btn-primary float-end mt-2" data-bs-toggle="modal" data-bs-target="#basicModalCustomer">
                        <i class='bx bxs-user-pin'></i>Thêm khách hàng
                    </button>
                    <button type="button" class="btn btn-primary float-end mt-2" data-bs-toggle="modal" data-bs-target="#basicModal">
                        <i class='bx bxs-user-plus'></i>Thêm nhân viên
                    </button>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exLargeModal">
                        <i class='bx bx-message-alt-add'></i>Thêm quyền
                    </button>
                    <button @click="putUsersRoles()" class="btn btn-primary">Lưu</button>
                    <router-link :to="{ name: 'admin-permission' }" class="btn btn-danger me-sm-2">
                        Thoát
                    </router-link>
                </div>
                <div class="modal fade" id="basicModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel1">Thêm nhân viên</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">Tên nhân viên</label>
                                        <model-list-select :list="users" v-model="selectedUser" option-value="id" option-text="display_name" placeholder="Chọn tên nhân viên"></model-list-select>
                                    </div>
                                </div>
                                <div class="row g-2">
                                    <div class="col mb-0">
                                        <label for="emailBasic" class="form-label">Email</label>
                                        <model-list-select :list="users" v-model="selectedUser" option-value="id" option-text="email" placeholder="Chọn tên nhân viên"></model-list-select>
                                    </div>
                                    <div class="col mb-0">
                                        <label for="dobBasic" class="form-label">Số điện thoại</label>
                                        <select v-model="selectedUser" @change="filterByCustomer" disabled class="form-select" id="exampleFormControlSelect1" aria-label="Default select example" readonly>
                                            <option v-for="user in users" :value="user.id">{{ user.phone }}</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" @click="putUsersAssigned" class="btn btn-danger">Lưu </button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    Đóng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="basicModalCustomer" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel1">Thêm khách hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">Tên khách hàng</label>
                                        <model-list-select :list="customer" v-model="selectedCustomer" option-value="ID" option-text="customer_name" placeholder="Chọn tên nhân viên"></model-list-select>
                                    </div>
                                </div>
                                <div class="row g-2">
                                    <div class="col mb-0">
                                        <label for="emailBasic" class="form-label">Email</label>
                                        <model-list-select :list="customer" v-model="selectedCustomer" option-value="ID" option-text="customer_email" placeholder="Chọn tên nhân viên"></model-list-select>
                                    </div>
                                    <div class="col mb-0">
                                        <label for="dobBasic" class="form-label">Số điện thoại</label>
                                        <select v-model="selectedCustomer" @change="filterByCustomer" disabled class="form-select" id="exampleFormControlSelect1" aria-label="Default select example" readonly>
                                            <option v-for="customers in customer" :value="customers.ID">{{ customers.customer_phone }}</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" @click="putCustomerAssigned" class="btn btn-danger">Lưu </button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    Đóng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="exLargeModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-xl" role="document">
                        <div class="modal-content">
                            <div class="modal-body" id="both-scrollbars-example">
                                <div class="row">
                                    <div class="col-5">
                                        <table class="table table-striped table-borderless">
                                            <thead>
                                                <tr>
                                                    <th class="text-nowrap">
                                                        <input class="form-check-input" @click="toggleAllFunctions" type="checkbox" v-model="selectAllFunctions.show">
                                                        <label class="form-check-label form-left" for="permissionCheckbox0">Chức
                                                            năng</label>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="(permission, index) in permissions" :key="index">
                                                    <td class="text-nowrap">
                                                        <input class="form-check-input" type="checkbox" :id="'permissionCheckbox' + index" v-model="permission.checked" @change="handleFunctionClick(permission)">
                                                        <label class="form-check-label form-left" :for="'permissionCheckbox' + index">{{ permission.label }}</label>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="col-7">
                                        <div class="table-responsive ">
                                            <table class="table table-striped table-borderless permission-model">
                                                <thead>
                                                    <tr>
                                                        <th class="text-nowrap">
                                                            <label class="form-check-label form-left" for="permissionCheckbox0">Chức năng đã chọn</label>
                                                        </th>
                                                        <th>
                                                            <div class="form-check d-flex justify-content-center form-permission">
                                                                <label class="form-check-label" for="permissionCheckbox0">Xem</label>
                                                            </div>
                                                        </th>
                                                        <th>
                                                            <div class="form-check d-flex justify-content-center th-table form-permission">
                                                                <label class="form-check-label" for="permissionCheckbox0">Thêm</label>
                                                            </div>
                                                        </th>
                                                        <th>
                                                            <div class="form-check d-flex justify-content-center th-table form-permission">
                                                                <label class="form-check-label" for="permissionCheckbox0">Sửa</label>
                                                            </div>
                                                        </th>
                                                        <th>
                                                            <div class="form-check d-flex justify-content-center th-table form-permission">
                                                                <label class="form-check-label" for="permissionCheckbox0">Xóa</label>
                                                            </div>
                                                        </th>
                                                        <th>
                                                            <div class="form-check d-flex justify-content-center th-table form-permission">
                                                                <label class="form-check-label form-left" for="permissionCheckbox0">Ẩn</label>
                                                            </div>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="(permission, index) in permissions" :key="index">
                                                        <td v-if="permission.checked">
                                                            <span>{{ permission.label }}</span>
                                                        </td>
                                                        <td v-if="permission.checked">
                                                            <div class="form-check d-flex justify-content-center">
                                                                <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.create.checked" :disabled="permission.functions.show.disabled" />
                                                            </div>
                                                        </td>
                                                        <td v-if="permission.checked">
                                                            <div class="form-check d-flex justify-content-center">
                                                                <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.show.checked" :disabled="permission.functions.show.disabled" />
                                                            </div>
                                                        </td>
                                                        <td v-if="permission.checked">
                                                            <div class="form-check d-flex justify-content-center">
                                                                <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.edit.checked" :disabled="permission.functions.edit.disabled">
                                                            </div>
                                                        </td>
                                                        <td v-if="permission.checked">
                                                            <div class="form-check d-flex justify-content-center">
                                                                <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.delete.checked" :disabled="permission.functions.delete.disabled">
                                                            </div>
                                                        </td>
                                                        <td v-if="permission.checked">
                                                            <div class="form-check d-flex justify-content-center">
                                                                <input class="form-check-input" type="checkbox" :id="'removeCheckbox' + permission.module" v-model="permission.denied" @change="handRemovePermission($event, permission)">
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-danger mt-2" data-bs-dismiss="modal">
                                    Đóng
                                </button>
                                <button @click="putUsersRoles(selectedUserId)" class="btn btn-primary" id="#showToastPlacement">Lưu</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="table-responsive multi-collapse collapse mt-3" id="multiCollapseExample1">
                    <div class="row">
                        <div class="col-2">
                            <table class="table table-striped table-borderless ">
                                <thead>
                                    <tr>
                                        <th class="text-nowrap">
                                            <input class="form-check-input" @click="toggleAllFunctions" type="checkbox" v-model="selectAllFunctions.show">
                                            <label class="form-check-label form-left" for="permissionCheckbox0">Chức
                                                năng</label>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(permission, index) in permissions" :key="index">
                                        <td class="text-nowrap">
                                            <input class="form-check-input" type="checkbox" :id="'permissionCheckbox' + index" v-model="permission.checked" @change="handleFunctionClick(permission)">
                                            <label class="form-check-label form-left" :for="'permissionCheckbox' + index">{{
                                            permission.label }}</label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-10">
                            <div class="table-responsive ">
                                <table class="table table-striped table-borderless">
                                    <thead>
                                        <tr>
                                            <th class="text-nowrap">
                                                <label class="form-check-label form-left" for="permissionCheckbox0">Chức năng đã
                                                    chọn</label>
                                            </th>
                                            <th>
                                                <div class="form-check d-flex justify-content-center form-permission">
                                                    <label class="form-check-label" for="permissionCheckbox0">Xem</label>
                                                </div>
                                            </th>
                                            <th>
                                                <div class="form-check d-flex justify-content-center th-table form-permission">
                                                    <label class="form-check-label" for="permissionCheckbox0">Thêm</label>
                                                </div>
                                            </th>
                                            <th>
                                                <div class="form-check d-flex justify-content-center th-table form-permission">
                                                    <label class="form-check-label" for="permissionCheckbox0">Sửa</label>
                                                </div>
                                            </th>
                                            <th>
                                                <div class="form-check d-flex justify-content-center th-table form-permission">
                                                    <label class="form-check-label" for="permissionCheckbox0">Xóa</label>
                                                </div>
                                            </th>
                                            <th>
                                                <div class="form-check d-flex justify-content-center th-table form-permission">
                                                    <label class="form-check-label form-left" for="permissionCheckbox0">Ẩn</label>
                                                </div>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(permission, index) in permissions" :key="index">
                                            <td v-if="permission.checked">
                                                <span>{{ permission.label }}</span>
                                            </td>
                                            <td v-if="permission.checked">
                                                <div class="form-check d-flex justify-content-center">
                                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.create.checked" :disabled="permission.functions.show.disabled" />
                                                </div>
                                            </td>
                                            <td v-if="permission.checked">
                                                <div class="form-check d-flex justify-content-center">
                                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.show.checked" :disabled="permission.functions.show.disabled" />
                                                </div>
                                            </td>
                                            <td v-if="permission.checked">
                                                <div class="form-check d-flex justify-content-center">
                                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.edit.checked" :disabled="permission.functions.edit.disabled">
                                                </div>
                                            </td>
                                            <td v-if="permission.checked">
                                                <div class="form-check d-flex justify-content-center">
                                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.delete.checked" :disabled="permission.functions.delete.disabled">
                                                </div>
                                            </td>
                                            <td v-if="permission.checked">
                                                <div class="form-check d-flex justify-content-center">
                                                    <input class="form-check-input" type="checkbox" :id="'removeCheckbox' + permission.module" v-model="permission.denied" @change="handRemovePermission($event, permission)">
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer mt-3">
                            <router-link :to="{ name: 'admin-permission' }" class="btn btn-danger me-sm-2">
                                Thoát
                            </router-link>
                            <button @click="putUsersRoles(selectedUserId)" class="btn btn-primary">Lưu</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="demo-inline-spacing mt-4">
                <small class="text-light">Công ty</small>
                <div class="list-group">
                    <template v-for="item in company">
                        <label class="list-group-item">
                            <input class="form-check-input me-1" type="checkbox" :value="item.id" v-model="selectedCompanny">
                            {{ item.name }}
                        </label>
                    </template>
                </div>
            </div>
            <button type="button" class="btn btn-outline-secondary mt-3" @click="resetCompany">
                <i class='bx bx-reset'></i> Reset
            </button>
        </div>
    </div>
</div>
<div class="nav-align-top mb-4 mt-4">
    <ul class="nav nav-pills mb-3" role="tablist">
        <li class="nav-item">
            <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-home" aria-controls="navs-pills-top-home" aria-selected="true">
                Phân quyền chức năng
            </button>
        </li>
        <li class="nav-item">
            <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-profile" aria-controls="navs-pills-top-profile" aria-selected="false">
                Phân quyền dữ liệu
            </button>
        </li>
        <li class="nav-item">
            <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-pills-top-customer" aria-controls="navs-pills-top-profile" aria-selected="false">
                Phân quyền khách hàng
            </button>
        </li>
        
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade show active" id="navs-pills-top-home" role="tabpanel">
            <div class="table-responsive text-nowrap">
                <table class="table table-striped table-borderless">
                    <thead>
                        <tr>
                            <th class="text-nowrap">
                                <label class="form-check-label" for="permissionCheckbox0">Chức năng</label>
                            </th>
                            <th>
                                <div class="form-check d-flex justify-content-center">
                                    <label class="form-check-label form-left" for="permissionCheckbox0">Danh sách</label>
                                </div>
                            </th>
                            <th>
                                <div class="form-check d-flex justify-content-center th-table">
                                    <label class="form-check-label form-left" for="permissionCheckbox0">Thêm</label>
                                </div>
                            </th>
                            <th>
                                <div class="form-check d-flex justify-content-center th-table">
                                    <label class="form-check-label form-left" for="permissionCheckbox0">Sửa</label>
                                </div>
                            </th>
                            <th>
                                <div class="form-check d-flex justify-content-center th-table">
                                    <label class="form-check-label form-left" for="permissionCheckbox0">Xóa</label>
                                </div>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(permission, index) in permissions" :key="index">
                            <td v-if="permission.checked">
                                <span>{{ permission.label }}</span>
                            </td>
                            <td v-if="permission.checked">
                                <div class="form-check d-flex justify-content-center">
                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.create.checked" disabled />
                                </div>
                            </td>
                            <td v-if="permission.checked">
                                <div class="form-check d-flex justify-content-center">
                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.show.checked" disabled />
                                </div>
                            </td>
                            <td v-if="permission.checked">
                                <div class="form-check d-flex justify-content-center">
                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.edit.checked" disabled>
                                </div>
                            </td>
                            <td v-if="permission.checked">
                                <div class="form-check d-flex justify-content-center">
                                    <input class="form-check-input" type="checkbox" :id="'showCheckbox' + permission.module" v-model="permission.functions.delete.checked" disabled>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
        <div class="tab-pane fade" id="navs-pills-top-profile" role="tabpanel">
            <div class="table-responsive text-nowrap">
                <table class="table table-bordered mb-4">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên nhân viên</th>
                            <th>Email</th>
                            <th>Khu vực</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(userAssigned, index) in usersAssignedID" :key="index">                          
                            <td>{{ index + 1 }}</td>
                            <td>{{ userAssigned.display_name }}</td>
                            <td>{{ userAssigned.email }}</td>
                            <td>{{ getStoreName(userAssigned.store_id) }}</td>
                            <td>{{ userAssigned.phone }}</td>
                            <td>
                                <span v-if="userAssigned.user_status === 1" class="badge rounded-pill bg-success"> Hoạt động
                                </span>
                                <span v-else class="badge rounded-pill bg-danger"> Ngừng động </span>
                            </td>
                            <td class="text-center">
                                <a @click="deleteUsers(userAssigned.id)" href="javascript:void(0);"><i class="bx bx-trash text-dark"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="tab-pane fade" id="navs-pills-top-customer" role="tabpanel">
                <div class="input-group input-group-merge">
                    <span class="input-group-text" id="basic-addon-search31">
                        <i class="bx bx-search"></i>
                    </span>
                    <input class="form-control"  v-model="searchTerm" id="html5-search-input" type="text" placeholder="Hãy nhập thông tin tìm kiếm...">
                </div>
                <div class="row mt-3">
                    <div class="col-md-2"><button @click="searchCustomers" type="button" class="btn btn-outline-danger"><i class="bx bx-search-alt"></i> Xem kết quả </button></div>
                    <div class="col-md">
                        <button type="button" class="btn btn-outline-primary float-end" data-bs-toggle="modal" data-bs-target="#basicModalReplaceCustomer"><i class='bx bxs-user-account'></i> Chuyển khách hàng</button>
                    </div>
                    
                </div>
                <div class="modal fade" id="basicModalReplaceCustomer" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel1">Chuyển đổi khách hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col mb-3">
                                        <label for="nameBasic" class="form-label">Tên nhân viên</label>
                                        <model-list-select :list="users" v-model="selectedUserConvert" option-value="id" option-text="display_name" placeholder="Chọn tên nhân viên"></model-list-select>
                                    </div>
                                </div>
                                <div class="row g-2">
                                    <div class="col mb-0">
                                        <label for="emailBasic" class="form-label">Email</label>
                                        <model-list-select :list="users" v-model="selectedUserConvert" option-value="id" option-text="email" placeholder="Chọn tên nhân viên"></model-list-select>
                                    </div>
                                    <div class="col mb-0">
                                        <label for="dobBasic" class="form-label">Số điện thoại</label>
                                        <select v-model="selectedUserConvert" disabled class="form-select" id="exampleFormControlSelect1" aria-label="Default select example" readonly>
                                            <option v-for="user in users" :value="user.id">{{ user.phone }}</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" @click="convertCustomer" class="btn btn-danger">Lưu </button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    Đóng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
            <table class="table table-bordered mb-4 mt-3">
                <thead>
                    <tr>
                        <th></th>
                        <th>STT</th>
                        <th>Mã khách hàng</th>
                        <th>Tên khách hàng</th>
                        <th>Điện thoại</th>
                        <th>Địa chỉ</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(customerAssigneds, index) in customerAssigned" :key="index">
                        <td><input 
                            type="checkbox" :id="'checkbox-' + customerAssigneds.ID" @click="customerClick(customerAssigneds.ID)" class="form-check-input mt-2" :value="customerAssigneds.ID"></td>
                        <td>{{ index + 1 }}</td>
                        <td>{{ customerAssigneds.customer_code }}</td>
                        <td>{{ customerAssigneds.customer_name }}</td>
                        <td>{{ getStoreName(customerAssigneds.customer_phone) }}</td>
                        <td>{{ customerAssigneds.customer_addr }}</td>
                        <td class="text-center">
                            <a @click="deleteCustomer(customerAssigneds.ID)" href="javascript:void(0);"><i class="bx bx-trash text-dark"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import {
    defineComponent,
    ref,
    onMounted,
    computed,
    watch
} from 'vue';
import {
    useToast
} from 'vue-toast-notification';
import {
    useRouter,
    useRoute
} from "vue-router";
import {
    inject
} from 'vue';
import {
    ModelListSelect
} from 'vue-search-select';
export default defineComponent({
    components: {
        ModelListSelect,
    },
    setup() {
        const globalState = inject('globalState');
        const baseUrl = globalState.baseUrl;
        const router = useRouter();
        const route = useRoute();
        const toast = useToast();
        const errors = ref([]);
        const stores = ref([]);
        const role = ref([]);
        const roles = ref([]);
        const roleUser = ref([]);
        const userRoles = ref([]);
        const customer = ref([]);
        const isActive = ref(true);
        const users = ref([]);
        const selectedCompanny = ref([]);
        const company = ref([]);
        const customerAssigned = ref([]);
        const usersAssignedID = ref([]);
        const searchTerm = ref('');
        const selectedUserConvert = ref([]);
        const customerCheckbox = ref([]);
        const usersAssigned = ref({
            display_name: '',
            email: '',
            phone: '',
        });
        const selectedUser = ref("");
        const selectedCustomer = ref("");
        const user = ref({
            display_name: "",
            email: "",
            phone: "",
            store_id: "",
            user_status: "",
        });
        const selectedFunctions = ref([]);
        const selectAllFunctions = ref({
            show: false,
            create: false,
            edit: false,
            delete: false,
        });
        const permissions = ref([{
                label: 'Đơn hàng',
                checked: false,
                module: 'order',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Khách hàng',
                checked: false,
                module: 'customer',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Công nợ',
                checked: false,
                module: 'debts',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Sản phẩm',
                checked: false,
                module: 'product',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Thiết lập',
                checked: false,
                module: 'setting',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Người dùng',
                checked: false,
                module: 'users',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Danh mục sản phẩm',
                checked: false,
                module: 'category',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Nhà kho',
                checked: false,
                module: 'stores',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Đơn vị tính',
                checked: false,
                module: 'productsUnit',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Thống kê',
                checked: false,
                module: 'chart',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Thống kê quản lý',
                checked: false,
                module: 'analytic',
                functions: {
                    show: {
                        checked: false
                    },
                    create: {
                        checked: false
                    },
                    edit: {
                        checked: false
                    },
                    delete: {
                        checked: false
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo tổng quan thầu',
                checked: false,
                module: 'contractor',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo theo dõi tham gia thầu',
                checked: false,
                module: 'biddingParticipate',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo theo dõi tham gia bán hàng',
                checked: false,
                module: 'biddingContractorOrder',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Tổng quan marketing',
                checked: false,
                module: 'marketing',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Tổng quan bán hàng',
                checked: false,
                module: 'orderCustomer',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Tổng quan bán hàng chi nhánh và sản phẩm',
                checked: false,
                module: 'biddingOrder',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Công nợ phải thu',
                checked: false,
                module: 'biddingDebts',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo tồn kho',
                checked: false,
                module: 'biddingInventory',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo tồn kho HSD 12 tháng',
                checked: false,
                module: 'biddingInventoryDate',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo hàng hủy',
                checked: false,
                module: 'inventoryDateDelete',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    }
                },
                denied: false,
            },
            {
                label: 'Báo cáo tổng hợp bán hàng , công nợ theo Asm',
                checked: false,
                module: 'salessummary',
                functions: {
                    show: {
                        checked: false,
                        disabled: true,
                    },
                    create: {
                        checked: false,
                        disabled: true,
                    },
                    edit: {
                        checked: false,
                        disabled: true,
                    },
                    delete: {
                        checked: false,
                        disabled: true,
                    },
                },
                denied: false,
            }

        ]);
        const toggleAllFunctions = () => {
            if (selectAllFunctions.value) {
                const newState = !selectAllFunctions.value.show;
                permissions.value.forEach((permission) => {
                    permission.checked = newState;
                    Object.keys(permission.functions).forEach((func) => {
                        permission.functions[func].checked = newState;
                    });
                });
            }
        };
        const handleFunctionClick = (permission) => {
            if (permission.checked) {
                permission.functions.show.checked = true;
                permission.functions.create.checked = true;
                permission.functions.edit.checked = true;
                permission.functions.delete.checked = true;
                permission.functions.show.disabled = false;
                permission.functions.create.disabled = false;
                permission.functions.edit.disabled = false;
                permission.functions.delete.disabled = false;
            } else {
                permission.functions.show.checked = false;
                permission.functions.create.checked = false;
                permission.functions.edit.checked = false;
                permission.functions.delete.checked = false;
                permission.functions.show.disabled = true;
                permission.functions.create.disabled = true;
                permission.functions.edit.disabled = true;
                permission.functions.delete.disabled = true;
            }
        };
        const watchedPermissions = computed(() => {
            return permissions.value;
        });
        const handRemovePermission = (event, permission) => {
            if (permission.denied) {
                permission.functions.show.checked = false;
                permission.functions.create.checked = false;
                permission.functions.edit.checked = false;
                permission.functions.delete.checked = false;
                permission.functions.show.disabled = true;
                permission.functions.create.disabled = true;
                permission.functions.edit.disabled = true;
                permission.functions.delete.disabled = true;
            } else {
                permission.functions.show.disabled = false;
                permission.functions.create.disabled = false;
                permission.functions.edit.disabled = false;
                permission.functions.delete.disabled = false;
                permission.functions.show.checked = true;
                permission.functions.create.checked = true;
                permission.functions.edit.checked = true;
                permission.functions.delete.checked = true;
            }
        };
        watch(permissions, (newPermissions, oldPermissions) => {
            newPermissions.forEach((permission, index) => {
                if (permission.checked !== oldPermissions[index].checked) {
                    handleFunctionClick(permission.label);
                }
            });
        });
        const getUsersRoles = async () => {
            try {
                const response = await axios.get(`${baseUrl}/api/user/${route.params.id}/roles`);
                const {
                    user: userData,
                    stores: {
                        data: storeData
                    },
                    company: companyData,
                } = response.data;
                isActive.value = userData.user_status === 1;
                user.value = {
                    display_name: userData.display_name,
                    email: userData.email,
                    phone: userData.phone,
                    store_id: userData.store_id,
                    company_id: userData.company_id,
                };
                company.value = companyData;
                stores.value = storeData;
                userRoles.value = response.data.roles[0].id;
                selectedCompanny.value = companyData.filter(company => userData.company_id.includes(company.id)).map(company => company.id);
            } catch (error) {
                console.error('Error fetching user permissions:', error);
            }
        };
        const getRolesPermission = async () => {
            try {
                const response = await axios.get(`${baseUrl}/api/roles`);
                roles.value = response.data;
            } catch (error) {
                console.error(error);
            }
        };
        const getUserPermission = async () => {
            try {
                const response = await axios.get(`${baseUrl}/api/user/${route.params.id}/permission`);
                const userPermissions = response.data.permissions;
                permissions.value.forEach((permission) => {
                    const foundPermission = userPermissions.find((perm) => perm.name === permission.module);
                    if (foundPermission) {
                        permission.checked = true;
                        ['show', 'create', 'edit', 'delete'].forEach((func) => {
                            const funcPermission = `${foundPermission.name}.${func}`;
                            const matchingPermission = userPermissions.find(
                                (perm) => perm.name === funcPermission
                            );
                            if (matchingPermission && matchingPermission.pivot.block == 1) {
                                permission.denied = true;
                                permission.functions[func].checked = false;
                                permission.denied = true;
                            } else {
                                permission.functions[func].checked = true;
                                permission.denied = false;
                            }
                        });
                    }
                });
            } catch (error) {
                console.error('Error fetching user permissions:', error);
            }
        };
        const putUsersRoles = () => {
            const selectedPermissions = [];
            const deniedPermissions = [];
            watchedPermissions.value.forEach((permission) => {
                if (permission.module && permission.functions && permission.checked) {
                    if (permission.denied) {
                        Object.keys(permission.functions).forEach((func) => {
                            const permissionString = `${permission.module}.${func}`;
                            deniedPermissions.push(permissionString);
                        });
                        deniedPermissions.push(permission.module);
                    } else {
                        Object.keys(permission.functions).forEach((func) => {
                            if (permission.functions[func].checked) {
                                const permissionString = `${permission.module}.${func}`;
                                selectedPermissions.push(permissionString);
                            }
                        });
                        selectedPermissions.push(permission.module);
                    }
                }
            });
            axios
                .put(`/api/user/${route.params.id}/permissions`, {
                    display_name: user.value.display_name,
                    email: user.value.email,
                    phone: user.value.phone,
                    store_id: user.value.store_id,
                    company_id: selectedCompanny.value,
                    permissions: selectedPermissions,
                    denied_permissions: deniedPermissions,
                    user_status: isActive.value ? 1 : 0,
                    userRoles: userRoles.value,
                })
                .then((response) => {
                    window.location.reload();
                    toast.success('Cập nhật quyền thành công');
                })
                .catch((error) => {
                    console.error('Error updating permissions:', error.response.data);
                });
        };
        const getUsers = async () => {
            try {
                const response = await axios.get(`${baseUrl}/api/getUser`);
                users.value = response.data.users;
            } catch (error) {
                console.error('Error fetching users:', error);
            }
        };
        const getUsersAssigned = async () => {
            try {
                const response = await axios.get(`${baseUrl}/api/permissionData/${route.params.id}/show`);
                usersAssigned.value = response.data.users;
                usersAssignedID.value = response.data.usersAssigned;
                console.log(usersAssignedID.value);
                stores.value = response.data.stores;
            } catch (error) {
                console.error('Error fetching user permissions:', error);
            }
        };
        const putUsersAssigned = async () => {
            try {
                const response = await axios.post(`${baseUrl}/api/permissionData/${route.params.id}/show`, {
                    selectedUser: selectedUser.value,
                });
                usersAssigned.value = response.data.users;
                toast.success('Bạn đã thêm người dùng thành công');
                selectedUser.value = '';
                getUsersAssigned();
            } catch (error) {
                console.error('Error adding user:', error);
            }
        };
        const getStoreName = (storeId) => {
            const store = stores.value.find((x) => x.ID === storeId);
            return store ? store.store_name : '';
        };
        const deleteUsers = (userId) => {
            const idUserDelete = route.params.id;
            axios
                .put(`${baseUrl}/api/permissionData/${userId}`, {
                    idUserDelete
                })
                .then((response) => {
                    getUsersAssigned();
                    toast.success('Xoá người dùng thành công');
                })
                .catch((error) => {
                    console.log(error);
                    toast.error('Xoá người dùng thất bại');
                });
        };

        const searchCustomers = () => {
            const term = searchTerm.value.toLowerCase();
            customerAssigned.value = customerAssigned.value.filter(customer =>
                customer.customer_code.toLowerCase().includes(term) ||
                customer.customer_name.toLowerCase().includes(term)
            );
            };
        const customerAddToUser = () => {
            axios
                .get(`${baseUrl}/api/getCustomerToUser`)
                .then((response) => {
                    customer.value = response.data.customer;
                })
                .catch((error) => {
                    console.log(error);
                });
        }
        const getCustomerAddToUser = () => {
            axios
                .get(`${baseUrl}/api/getCustomerToUser/${route.params.id}`)
                .then((response) => {
                    customerAssigned.value = response.data.customerAssigned;
                })
                .catch((error) => {
                    console.log(error);
                });
        }
        const selectedCustomerIds = ref([]);

        const customerClick = (customerAssignedId) => {
            const index = selectedCustomerIds.value.indexOf(customerAssignedId);
            if (index === -1) {
                selectedCustomerIds.value.push(customerAssignedId);
            } else {
                selectedCustomerIds.value.splice(index, 1);
            }

            console.log('Selected Customer IDs:', selectedCustomerIds.value);
        };
        const convertCustomer = () => {
            axios
                .post(`${baseUrl}/api/getCustomerToConvert/${route.params.id}`, {
                    selectedUserConvert: selectedUserConvert.value,
                    customerCheckboxes: selectedCustomerIds.value,
                })
                .then((response) => {
                    toast.success('Chuyển người dùng thành công');
                })
                .catch((error) => {
                    toast.error('Chuyển đổi thất bại');
                });
        };
        const putCustomerAssigned = async () => {
            try {
                const response = await axios.put(`${baseUrl}/api/postCustomerToUser/${route.params.id}`, {
                    selectedCustomer: selectedCustomer.value,
                    customerCheckboxes: selectedCustomerIds.value,
                });
                getCustomerAddToUser(); 
                toast.success('Bạn đã thêm người dùng thành công');
            } catch (error) {
                console.error('Error adding user:', error);
            }
        };
        const deleteCustomer = (customerID) => {
            axios
                .put(`${baseUrl}/api/putCustomerToUser/${customerID}`)
                .then((response) => {
                    getCustomerAddToUser();
                    toast.success('Xoá người dùng thành công');
                })
                .catch((error) => {
                    console.log(error);
                    toast.error('Xoá người dùng thất bại');
                });
        }
        const resetCompany = async () => {
            try {
                const response = await axios.put(`${baseUrl}/api/getCompany/${route.params.id}`);
                toast.success('Bạn đã reset công ty thành công');
                window.location.reload();
            } catch (error) {
                console.error('Error adding user:', error);
            }
        }
        
        onMounted(() => {
            getUsersRoles();
            getUserPermission();
            getUsers();
            getUsersAssigned();
            getCustomerAddToUser();
            customerAddToUser();
            getRolesPermission();
        });
        return {
            role,
            errors,
            stores,
            user,
            permissions,
            selectAllFunctions,
            isActive,
            selectedFunctions,
            handleFunctionClick,
            handRemovePermission,
            putUsersRoles,
            roles,
            toggleAllFunctions,
            roleUser,
            userRoles,
            users,
            usersAssigned,
            selectedUser,
            selectedCustomer,
            putUsersAssigned,
            usersAssignedID,
            stores,
            getStoreName,
            deleteUsers,
            customer,
            putCustomerAssigned,
            customerAssigned,
            deleteCustomer,
            company,
            selectedCompanny,
            resetCompany,
            searchCustomers,
            searchTerm,
            convertCustomer,
            selectedUserConvert,
            customerCheckbox,
            customerClick
        };
    },
});
</script>
