import CSI 1.0

Module
{
    id: module
    property int deck: 1
    property bool enabled: true

    StripeProvider { name: "stripe_provider"; channel: module.deck; width: 600; height: 40 }
    Wire { enabled: module.enabled; from: "surface.stripe_info"; to: "stripe_provider.output" }
    Wire { enabled: module.enabled; from: "stripe_provider.color"; to: ValuePropertyAdapter { path: "app.traktor.settings.waveform.color"; input: false } }

}
