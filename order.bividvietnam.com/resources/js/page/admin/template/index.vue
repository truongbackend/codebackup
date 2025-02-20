<template>
<div>
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">Thiết lập /</span> Mẫu hóa đơn
    </h4>
    <div>
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="row">
                    <label class="col-sm-2 col-form-label" for="basic-icon-default-fullname">Chọn mẫu</label>
                    <div class="col-sm-5">
                        <select @change="updateContentFromTemplate" v-model="selectedTemplate" class="form-select" id="exampleFormControlSelect1" aria-label="Default select example">
                            <option v-for="template in templates" :value="template.id">{{ template.name }}</option>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-primary" @click="saveContentToDatabase">Gửi</button>
                    </div>
                </div>
                <ckeditor :editor="editor" v-model="content" />
            </div>
            <div class="col-md-6">
                <div class="row">
                    <label class="col-sm-4 col-form-label" for="basic-icon-default-fullname">Xem trước mẫu in</label>
                    <blockquote class="blockquote mt-1 border card-body text-left">
                        <span v-html="content"></span>
                    </blockquote>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

  
<script>
import axios from "axios";
import { defineComponent, ref, onMounted } from "vue";
import { useToast } from "vue-toast-notification";
import { inject } from "vue";
import ClassicEditor from "@ckeditor/ckeditor5-build-classic";

export default defineComponent({
    setup() {
        const toast = useToast();
        const templates = ref([]);
        const selectedTemplate = ref("");
        const globalState = inject("globalState");
        const baseUrl = globalState.baseUrl;

        const editor = ref(null);
        const content = ref("");
        const getTemplate = () => {
            axios
                .get(`${baseUrl}/api/template`)
                .then((response) => {
                    templates.value = response.data.template.data;
                    selectedTemplate.value = templates.value[0].id;
                    content.value = templates.value[0].content;
                })
                .catch((error) => {
                    console.log(error);
                });
        };

        const updateContentFromTemplate = () => {
            const selectedTemplateObj = templates.value.find((template) => template.id === selectedTemplate.value);
            if (selectedTemplateObj) {
                content.value = selectedTemplateObj.content;
            }
        };

        const saveContentToDatabase = () => {
            const selectedTemplateObj = templates.value.find((template) => template.id === selectedTemplate.value);
            if (selectedTemplateObj) {
                axios
                    .put(`${baseUrl}/api/template/${selectedTemplate.value}`, {
                        content: content.value,
                    })
                    .then((response) => {
                        toast.success("Bạn đã cập nhật mẫu hóa đơn thành công");
                    })
                    .catch((error) => {
                        console.error(error);
                        toast.error("Error saving content.");
                    });
            }
        };

        onMounted(() => {
            ClassicEditor.create('#editor'), {
                toolbar: [
                    'heading', '|', 'alignment:left', 'alignment:right', 'alignment:center', 'alignment:justify'
                ]
            };
            getTemplate();
        });

        return {
            editor: ClassicEditor,
            templates,
            selectedTemplate,
            content,
            updateContentFromTemplate,
            saveContentToDatabase,
        };
    },
});
</script>
