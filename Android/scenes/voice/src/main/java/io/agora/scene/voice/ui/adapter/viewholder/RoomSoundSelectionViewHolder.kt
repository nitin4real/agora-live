package io.agora.scene.voice.ui.adapter.viewholder

import android.os.Build
import android.text.Html
import android.view.View
import android.widget.LinearLayout
import androidx.core.view.isVisible
import io.agora.scene.base.component.BaseRecyclerViewAdapter
import io.agora.scene.voice.model.SoundSelectionBean
import io.agora.voice.common.utils.DeviceTools.dp
import io.agora.voice.common.utils.ResourcesTools
import io.agora.scene.voice.R
import io.agora.scene.voice.databinding.VoiceItemRoomSoundSelectionBinding
import io.agora.scene.voice.databinding.VoiceItemSoundSelectionFooterBinding

class RoomSoundSelectionViewHolder(binding: VoiceItemRoomSoundSelectionBinding) :
    BaseRecyclerViewAdapter.BaseViewHolder<VoiceItemRoomSoundSelectionBinding, SoundSelectionBean>(binding) {
    override fun binding(data: SoundSelectionBean?, selectedIndex: Int) {
        data?.let {
            if (it.isCurrentUsing) {
                mBinding.mtSoundSelectionCurrentName.isVisible = true
                mBinding.mtSoundSelectionCurrentName.text =
                    mBinding.root.context.getString(R.string.voice_chatroom_current_sound_selection)
                mBinding.mcvSoundSelectionContent.strokeColor =
                    ResourcesTools.getColor(itemView.context.resources, R.color.voice_main_color_009fff)
                mBinding.ivSoundSelectionToggle.setImageResource(R.drawable.voice_icon_room_sound_listen)
                mBinding.ivSoundSelected.isVisible = true
                mBinding.llSoundSelectionTips.isVisible = false
            } else {
                mBinding.mtSoundSelectionCurrentName.text =
                    mBinding.root.context.getString(R.string.voice_chatroom_other_sound_selection)
                mBinding.mtSoundSelectionCurrentName.isVisible = bindingAdapterPosition == 1
                mBinding.llSoundSelectionTips.isVisible = bindingAdapterPosition == 1
                mBinding.mcvSoundSelectionContent.strokeColor =
                    ResourcesTools.getColor(itemView.context.resources, R.color.voice_dark_grey_color_eff4ff)
                mBinding.ivSoundSelectionToggle.setImageResource(R.drawable.voice_icon_room_sound_toggle)
                mBinding.ivSoundSelected.isVisible = false
            }
            mBinding.mtSoundSelectionName.text = it.soundName
            mBinding.mtSoundSelectionContent.text = it.soundIntroduce
        }
    }

    private fun addCustomerMargin(view: View) {
        val layoutParams: LinearLayout.LayoutParams = view.layoutParams as LinearLayout.LayoutParams
        layoutParams.setMargins(0, 0, 10.dp.toInt(), 0)
        view.layoutParams = layoutParams
    }
}

class RoomSoundSelectionFooterViewHolder(binding: VoiceItemSoundSelectionFooterBinding) :
    BaseRecyclerViewAdapter.BaseViewHolder<VoiceItemSoundSelectionFooterBinding, String>(binding) {

    override fun binding(data: String?, selectedIndex: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            mBinding.mtChatroomSoundSelectionMore.text =
                Html.fromHtml(
                    itemView.context.getString(R.string.voice_chatroom_sound_selection_more),
                    Html.FROM_HTML_MODE_LEGACY
                )
        } else {
            mBinding.mtChatroomSoundSelectionMore.text =
                Html.fromHtml(itemView.context.getString(R.string.voice_chatroom_sound_selection_more))
        }
        mBinding.mtChatroomSoundSelectionMore.setOnClickListener {
            onItemChildClick("www.agora.io", it)
        }
    }
}